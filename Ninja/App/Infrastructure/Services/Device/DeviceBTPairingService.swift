//
//  DeviceBTPairingService.swift
//  Ninja
//
//  Created by Martin Burch on 1/6/23.
//

import Foundation
import Combine
import CoreBluetooth
import GrillCore

typealias BTJoinableGrill = GrillCoreSDK.BTJoinableGrill

enum BTPairingError {
    case InvalidUUID
    case ConnectionFailed
    case PeripheralError
}

class DeviceBTPairingService {
    
    static let characteristicUUIDs: [CBUUID] = [DeviceBTControlService.pairingWriteCharacteristicUUID, DeviceBTControlService.pairingReadCharacteristicUUID]

    private lazy var bluetoothService: BluetoothService = .shared()
    private var serviceDisposables = Set<AnyCancellable>()
    private var peripheralDisposables = Set<AnyCancellable>()

    let connectionSubject = CurrentValueSubject<CBManagerState, Never>(.poweredOff)
    let pairableGrillsSubject = CurrentValueSubject<[BTJoinableGrill], Never>([])
    let connectedPeripheralSubject = CurrentValueSubject<BluetoothPeripheral?, Never>(nil)
    let connectedPeripheralInfoSubject = CurrentValueSubject<BTLEInfo?, Never>(nil)
    let connectedPeripheralTokenSubject = CurrentValueSubject<String?, Never>(nil)
    let peripheralConnectionSubject = PassthroughSubject<(BluetoothPeripheralConnectionState, CBPeripheral), Never>()
    
    let wifiNetworksSubject = CurrentValueSubject<[BTLEWifiNetwork], Never>([])
    let wifiNetworkStatusSubject = PassthroughSubject<BTLEWifiJoinStatus, Never>()
    var completedSubject = PassthroughSubject<String, Never>()
    let errorSubject = PassthroughSubject<BTPairingError, Never>()
    
    private var currentlyPairing = false
    private var wifiNetworks: [UInt16: BTLEWifiNetwork] = [:]
    private var wifiTimer: Timer? = nil
    
    private static var _instance: DeviceBTPairingService = .init()
    static var shared: DeviceBTPairingService {
        get { _instance }
    }
    
    private init() {}
    
    deinit {
        serviceDisposables.removeAll()
        peripheralDisposables.removeAll()
    }
    
    func listenToPairing() {
        serviceDisposables.removeAll()
        
        bluetoothService.connectionSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] state in
            self?.connectionSubject.send(state) // TODO: convert to calculated property???
            Logger.Debug("BT_PAIRING: SERVICE STATE: \(state)")
        }.store(in: &serviceDisposables)
        bluetoothService.peripheralsSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] peripherals in
            self?.pairableGrillsSubject.send(BTManager.shared.joinableGrills()) // TODO: send on a schedule???
            Logger.Debug("BT_PAIRING: SERVICE PERIPHERALS: \(peripherals.count)")
        }.store(in: &serviceDisposables)
        bluetoothService.peripheralConnectionSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] (state, peripheral) in
            self?.peripheralConnectionSubject.send((state, peripheral))
            Logger.Debug("BT_PAIRING: SERVICE PERIPHERAL STATE: \(state)")
        }.store(in: &serviceDisposables)
    }
    
    private func listenToPeripheral(peripheral: BluetoothPeripheral) {
        peripheralDisposables.removeAll()
        
        peripheral.characteristicUpdateSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] message in
            guard let self = self else { return }
            if let encryptedData = message.value {
                let data = self.decryptOrData(uuid: peripheral.peripheral.identifier.uuidString, data: encryptedData)
                let messageType = self.getDataType(data: data)
                Logger.Debug("BT_PAIRING: SERVICE UPDATE RECEIVED, ENCODED: \(data != encryptedData), TYPE: \(String(describing: messageType))")
                Logger.Debug("BT_PAIRING: BTLE Message: \(data)")
                switch messageType {
                case .WiFiScanResult:
                    if let wifiNetwork = self.decodeBTWifiConnection(data: data) {
                        if wifiNetwork.index == 0 {
                            self.wifiNetworks.removeAll()
                        }
                        self.wifiNetworks[wifiNetwork.index] = wifiNetwork
                        
//                        Logger.Debug("ServiceTotalCount \(self?.wifiNetworks.count ?? 0) : CountFromDevice \(wifiNetwork.totalCount) : CurrentIndex \(wifiNetwork.index) : SSID \(wifiNetwork.ssid ?? "")")
                        if wifiNetwork.index <= wifiNetwork.totalCount - 1 {
                            self.wifiNetworksSubject.send(
                                self.wifiNetworks.values.unique()
                                    .filter({ network in !(network.ssid?.isEmpty ?? true) })
                                    .sorted(by: { one, two in one.index < two.index }))
                        }
                    }
                case .WiFiJoinStatus:
                    if let status = self.decodeBTWifiConnectionStatus(data: data) {
                        self.wifiNetworkStatusSubject.send(status)
                    }
                case .GrillInfoResponse:
                    if let infoResponse = self.decodeBTInfoResponse(data: data) {
                        self.connectedPeripheralInfoSubject.send(infoResponse)
                    }
                default:
                    break
                }
            }
        }.store(in: &peripheralDisposables)
        peripheral.discoverySubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] state in
            switch state {
            case .CHARACTERISTICS(let service):
                if DeviceBTControlService.serviceUUIDs.contains(service.uuid) {
                    self?.getConnectedDeviceInfo()
                }
            default:
                break
            }
        }.store(in: &peripheralDisposables)
        peripheral.errorSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] state in
            self?.errorSubject.send(.PeripheralError)
        }.store(in: &peripheralDisposables)
    }
    
    func connectToBluetooth() {
        Logger.Debug("BT_PAIRING: SERVICE CONNECT TO BLUETOOTH")
        _ = bluetoothService.getFoundPeripherals()
    }
    
    func disconnectBluetooth() {
        Logger.Debug("BT_PAIRING: SERVICE DISCONNECT FROM BLUETOOTH")
        BluetoothService.kill()
    }
    
    // MARK: SCANNING
    func initializeScan() {
        bluetoothService.initializeScan()
        
        pairableGrillsSubject.send([])
    }
    
    func startDeviceScan() {
        Logger.Debug("BT_PAIRING: SERVICE START SCAN")
        bluetoothService.startScan(cbuuids: DeviceBTControlService.serviceUUIDs)
    }
    
    func stopDeviceScan() {
        Logger.Debug("BT_PAIRING: SERVICE STOP SCAN")
        bluetoothService.stopScan()
    }
    
    func isDeviceScanning() -> Bool {
        return bluetoothService.isScanning()
    }

    // MARK: PERIPHERALS
    func getPeripheral(uuidString: String) -> CBPeripheral? {
        if let uuid = UUID(uuidString: uuidString) {
            return bluetoothService.findPeripheral(uuid: uuid)
        }
        return nil
    }
    
    func connectToDevice(peripheral: CBPeripheral) {
        Logger.Debug("BT_PAIRING: SERVICE CONNECT DEVICE")
        connectedPeripheralTokenSubject.send(DeviceBTPairingService.generateRandomString(length: 8))
        if let connectedPeripheral = bluetoothService.connectPeripheral(peripheral: peripheral) {
            connectedPeripheralSubject.send(connectedPeripheral)
            listenToPeripheral(peripheral: connectedPeripheral)
        } else {
            Logger.Debug("BT_PAIRING: SERVICE CONNECT DEVICE FAILED")
            errorSubject.send(.ConnectionFailed)
        }
    }
    
    func getConnectedDeviceInfo() {
        Logger.Debug("BT_PAIRING: SERVICE GET INFO")
        if let wrapper = connectedPeripheralSubject.value,
           let characteristic = wrapper.peripheral.services?.first?.characteristics?.first(where: { $0.uuid.uuidString == DeviceBTControlService.pairingWriteCharacteristicUUID.uuidString }) {
            let data = encodeBTInfoRequest()
            Logger.Debug("DATA: \(Array(data))")
            let encodedData = encryptOrData(uuid: wrapper.peripheral.identifier.uuidString, data: data)
            wrapper.peripheral.writeValue(encodedData, for: characteristic, type: .withResponse)
            Logger.Debug("BT_PAIRING: SERVICE GET INFO ENCODED: \(!encodedData.isEmpty)")
        }
    }
    
    // MARK: WIFI PAIRING
    func startWifiNetworkScan() {
        wifiNetworks.removeAll()
        wifiNetworksSubject.send([])
        
        Logger.Debug("BT_PAIRING: SERVICE START SCAN")
        if let wrapper = connectedPeripheralSubject.value,
           let characteristic = wrapper.peripheral.services?.first?.characteristics?.first(where: { $0.uuid.uuidString == DeviceBTControlService.pairingWriteCharacteristicUUID.uuidString }) {
            let data = encodeBTWifiScanRequest()
            Logger.Debug("DATA: \(Array(data))")
            let encodedData = encryptOrData(uuid: wrapper.peripheral.identifier.uuidString, data: data)
            wrapper.peripheral.writeValue(encodedData, for: characteristic, type: .withResponse)
           Logger.Debug("BT_PAIRING: SERVICE START SCAN ENCODED: \(!encodedData.isEmpty)")
        }
    }
    
    func stopWifiNetworkScan() {
        Logger.Debug("BT_PAIRING: SERVICE STOP SCAN")
        if let wrapper = connectedPeripheralSubject.value,
           let characteristic = wrapper.peripheral.services?.first?.characteristics?.first(where: { $0.uuid.uuidString == DeviceBTControlService.pairingWriteCharacteristicUUID.uuidString }) {
            let data = encodeBTWifiScanDone()
            Logger.Debug("DATA: \(Array(data))")
            let encodedData = encryptOrData(uuid: wrapper.peripheral.identifier.uuidString, data: data)
            wrapper.peripheral.writeValue(encodedData, for: characteristic, type: .withResponse)
            Logger.Debug("BT_PAIRING: SERVICE STOP SCAN ENCODED: \(!encodedData.isEmpty)")
        }
    }
    
    func joinWifiNetwork(ssid: String, password: String) {
        Logger.Debug("BT_PAIRING: SERVICE JOIN WIFI")
        if let wrapper = connectedPeripheralSubject.value,
            let token = connectedPeripheralTokenSubject.value,
            let characteristic = wrapper.peripheral.services?.first?.characteristics?.first(where: { $0.uuid.uuidString == DeviceBTControlService.pairingWriteCharacteristicUUID.uuidString }) {
                let data = encodeBTWifiJoinRequest(ssid: ssid, pwd: password, token: token)
                let encodedData = encryptOrData(uuid: wrapper.peripheral.identifier.uuidString, data: data)
                wrapper.peripheral.writeValue(encodedData, for: characteristic, type: .withResponse)
            Logger.Debug("BT_PAIRING: SERVICE JOIN WIFI ENCODED: \(!encodedData.isEmpty)")
        }
    }
    
    func completeBluetoothPairing() {
        if let peripheral = connectedPeripheralSubject.value?.peripheral {
            bluetoothService.disconnectPeripheral(peripheral: peripheral)
        }
        
        pairableGrillsSubject.send([])
        connectedPeripheralSubject.send(nil)
        connectedPeripheralTokenSubject.send(nil)
        wifiNetworksSubject.send([])
        
        peripheralDisposables.removeAll()
        Logger.Debug("BT_PAIRING: SERVICE COMPLETE")
    }
    
    private func decryptOrData(uuid: String, data: Data) -> Data {
        let decrypt = BTManager.shared.decryptData(uuid: uuid, data: data)
        return decrypt.isEmpty ? data : decrypt
    }
    
    private func encryptOrData(uuid: String, data: Data) -> Data {
        let encrypt = BTManager.shared.encryptData(uuid: uuid, data: data)
        return encrypt.isEmpty ? data : encrypt
    }
    
}


