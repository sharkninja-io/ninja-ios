//
//  DeviceBTControlService.swift
//  Ninja
//
//  Created by Martin Burch on 3/7/23.
//

import Foundation
import Combine
import CoreBluetooth
import GrillCore

typealias BTCommand = GrillCoreSDK.BTCommand
typealias BTManager = GrillCoreSDK.BTManager
typealias BTPayload = GrillCoreSDK.BTPayload

class DeviceBTControlService {
    
    private lazy var btService: BluetoothService = .shared()
    private var disposables = Set<AnyCancellable>()
    private var advertisementDisposables = Set<AnyCancellable>()
    private var peripheralDisposables = Set<AnyCancellable>()

    private var currentPeripheral: BluetoothPeripheral?
    private var currentBTObserver: NSKeyValueObservation? = nil
    
    static let unencryptedServiceUUID = CBUUID(string: "A00B")
    static let encryptedServiceUUID = CBUUID(string: "FCBB")
    static let serviceUUIDs = [unencryptedServiceUUID, encryptedServiceUUID]
    static let pairingWriteCharacteristicUUID = CBUUID(string: "B002")
    static let pairingReadCharacteristicUUID = CBUUID(string: "B004")
    static let advertisementDataKey = "kCBAdvDataManufacturerData"
    
    var isEnabled: Bool = true {
        didSet {
            // TODO: - pause / resume
        }
    }
    
    private static var _instance: DeviceBTControlService = .init()
    static var shared: DeviceBTControlService {
        get { _instance }
    }
    
    private init() { }
    
    deinit {
        advertisementDisposables.removeAll()
        stop()
        disposables.removeAll()
    }
    
    func start() {
        observeBTDevice()
        listenToBT()
        if advertisementDisposables.isEmpty {
            listenToAdvertisements()
        }
    }
    
    func stop() {
        currentBTObserver?.invalidate()
        currentBTObserver = nil
        peripheralDisposables.removeAll()
    }
    
    private func observeBTDevice() {
        currentBTObserver?.invalidate()
        currentBTObserver = BTManager.shared.observe(\.btAppRequest, options: [.old, .new], changeHandler: { [weak self] _, change in
            guard let self = self else { return }
            
            DispatchQueue.global(qos: .background).async {
                if change.oldValue != change.newValue, let package = change.newValue {
                    self.receiveBTDeviceData(enumType: package.cmd, deviceId: package.id, data: package.data)
                }
            }
        })
    }
    
    private func receiveBTDeviceData(enumType: BTCommand, deviceId: String, data: Data) {
        switch enumType {
        case .Connect:
            if let uuid = UUID(uuidString: deviceId), let peripheral = btService.findPeripheral(uuid: uuid) {
                currentPeripheral = btService.connectPeripheral(peripheral: peripheral)
                if let peripheral = currentPeripheral {
                    listenToPeripheral(peripheral: peripheral)
                }
            } else {
                // Send error
            }
            break
        case .Disconnect:
            // Disconnect
            if let uuid = UUID(uuidString: deviceId), let peripheral = btService.findConnectedPeripheral(uuid: uuid) {
                btService.disconnectPeripheral(peripheral: peripheral.peripheral)
                peripheralDisposables.removeAll()
                currentPeripheral = nil
            } else {
                // Send error
            }
            break
        case .Send:
            // Command
            let characteristicUUID = Self.pairingWriteCharacteristicUUID.uuidString
            if let uuid = UUID(uuidString: deviceId),
                    let peripheral = currentPeripheral ?? btService.findConnectedPeripheral(uuid: uuid),
                    let characteristic = peripheral.findCharacteristic(uuid: characteristicUUID) {
                peripheral.peripheral.writeValue(data, for: characteristic, type: .withResponse)
            }
            break
        case .StartScan:
            // Start scan
            btService.startScan(cbuuids: Self.serviceUUIDs)
            break
        case .StopScan:
            // Stop scan
            btService.stopScan()
            sendDeviceBTReponse(enumType: .StopScan, id: deviceId, data: Data()) // TODO: -
            break
        default:
            break
        }
    }
    
    func listenToAdvertisements() {
        advertisementDisposables.removeAll()
        btService.peripheralBroadCastSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] packet in
            // ADVERTISEMENT DATA
            self?.sendAdvertisementData(packet: packet)
        }.store(in: &advertisementDisposables)
    }
    
    func stopListeningToAdvertisements() {
        advertisementDisposables.removeAll()
    }
    
    private func listenToBT() {
        disposables.removeAll()
        btService.connectionSubject.receive(on: DispatchQueue.global(qos: .background)).sink { state in
            BTManager.shared.setBTAvailable(state == .poweredOn)
        }.store(in: &disposables)
        btService.peripheralConnectionSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] connection in
            // DISCONNECTED
            if connection.0 == .disconnected || connection.0 == .failedToConnect {
                self?.sendDeviceBTReponse(enumType: .Disconnect, id: connection.1.identifier.uuidString, data: Data())
            }
        }.store(in: &disposables)
    }
    
    private func listenToPeripheral(peripheral: BluetoothPeripheral) {
        peripheralDisposables.removeAll()
        peripheral.discoverySubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .CHARACTERISTICS(let service):
                if Self.serviceUUIDs.map({ $0.uuidString }).contains(service.uuid.uuidString) {
                    // CONNECTION COMPLETED
                    self.sendDeviceBTReponse(enumType: .Connect, id: peripheral.peripheral.identifier.uuidString, data: Data())
                }
            default:
                break
            }
        }.store(in: &peripheralDisposables)
        peripheral.characteristicUpdateSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] characteristic in
            // PACKET RECEIVED
            self?.sendDeviceBTReponse(enumType: .Send, id: peripheral.peripheral.identifier.uuidString, data: characteristic.value)
        }.store(in: &peripheralDisposables)
    }
    
    private func sendDeviceBTReponse(enumType: BTCommand, id: String, data: Data?) {
        let payload = BTPayload()
        payload.cmd = enumType
        payload.id = id
        payload.data = data ?? Data()

        Task {
            await BTManager.shared.sendBTPayload(payload)
        }
    }
    
    private func sendAdvertisementData(packet: BluetoothAdvertisementPacket) {
        if let data = packet.advertisementData.first(where: { $0.key == Self.advertisementDataKey })?.value as? Data {
            BTManager.shared.processAdvertisementData(
                uuid: packet.peripheral.identifier.uuidString,
                data: data,
                rssi: packet.RSSI.intValue
            )
        }
    }
}
