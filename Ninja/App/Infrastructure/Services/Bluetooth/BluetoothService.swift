//
//  BluetoothService.swift
//  Ninja
//
//  Created by Martin Burch on 8/18/22.
//

import Foundation
import CoreBluetooth
import Combine

enum BluetoothPeripheralConnectionState {
    case disconnected
    case connected
    case failedToConnect
}

struct BluetoothAdvertisementPacket {
    var peripheral: CBPeripheral
    var advertisementData: [String : Any]
    var RSSI: NSNumber
}

class BluetoothService: NSObject {
    
    var connectionSubject = CurrentValueSubject<CBManagerState, Never>(.poweredOff)
    var peripheralsSubject = PassthroughSubject<Dictionary<String, CBPeripheral>, Never>()
    var peripheralConnectionSubject = PassthroughSubject<(BluetoothPeripheralConnectionState, CBPeripheral), Never>()
    var peripheralBroadCastSubject = PassthroughSubject<BluetoothAdvertisementPacket, Never>()
    
    private var centralManager: CBCentralManager!
    private var foundPeripherals: [String: CBPeripheral] = [:]
    private var peripheralMonitors: [String: BluetoothPeripheral] = [:]
    private var peripheralServiceUUIDs: [CBUUID]? = nil
    
    private static var _instance: BluetoothService?
    
    static func shared() -> BluetoothService {
        if let instance = _instance {
            return instance
        }
        let instance: BluetoothService = .init()
        _instance = instance
        return instance
    }
    
    static func kill() {
        _instance = nil
    }
    
    override private init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    deinit {
        // TODO: //
        centralManager = nil
    }
    
    var isPermissionGranted: Bool {
        return CBCentralManager.authorization == .allowedAlways
    }
    
    // MARK: - SCANNING FUNCTIONS
    func initializeScan() {
        foundPeripherals.removeAll()
        peripheralsSubject.send(foundPeripherals)
    }
    
    func startScan(cbuuids: [CBUUID]? = nil) {
        if centralManager.state == .poweredOn && !centralManager.isScanning {
            initializeScan() // TODO: Needed???
            
            peripheralServiceUUIDs = cbuuids
            centralManager.scanForPeripherals(withServices: cbuuids)
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func isScanning() -> Bool {
        return centralManager.isScanning
    }
    
    func getFoundPeripherals() -> [String: CBPeripheral] {
        return foundPeripherals
    }
    
    // MARK: - PERIPHERAL FUNCTIONS
    func findPeripheral(uuid: UUID) -> CBPeripheral? {
        centralManager.retrievePeripherals(withIdentifiers: [uuid]).first
    }
    
    func findConnectedPeripheral(uuid: UUID) -> BluetoothPeripheral? {
        return peripheralMonitors[uuid.uuidString]
    }
    
    func connectPeripheral(peripheral: CBPeripheral) -> BluetoothPeripheral? {
        if peripheralMonitors[peripheral.identifier.uuidString] == nil {
            peripheralMonitors[peripheral.identifier.uuidString] = BluetoothPeripheral(peripheral: peripheral)
        }
        if peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.value == .disconnected ||
                peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.value == .disconnecting {
            peripheral.delegate = peripheralMonitors[peripheral.identifier.uuidString]
            centralManager.connect(peripheral)
        }
        return peripheralMonitors[peripheral.identifier.uuidString]
    }
    
    func disconnectPeripheral(peripheral: CBPeripheral?) {
        if let peripheral = peripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
            peripheralMonitors[peripheral.identifier.uuidString] = nil
       }
    }
    
    func getConnectedPeripherals() -> [String: BluetoothPeripheral] {
        return peripheralMonitors.filter { element in element.value.stateSubject.value == .connected }
    }
    
    func isPeripheralConnected(peripheral: CBPeripheral, cbuuids: [CBUUID]) -> Bool {
        return centralManager.retrieveConnectedPeripherals(withServices: cbuuids).contains(peripheral) // TODO: update
    }
}

// MARK: - CENTRAL MANAGER DELEGATE
extension BluetoothService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        connectionSubject.send(central.state)
        
        switch central.state {
        case .poweredOn:
            Logger.Debug("[BLUETOOTH POWERED ON]")
        case .poweredOff:
            Logger.Debug("[BLUETOOTH POWERED OFF]")
        case .resetting:
            Logger.Debug("[BLUETOOTH RESETTING]")
        case .unauthorized:
            Logger.Debug("[BLUETOOTH UNAUTHORIZED]")
            switch CBCentralManager.authorization {
            case .notDetermined:
                Logger.Debug("Bluetooth authorization is not determined")
            case .restricted:
                Logger.Debug("Bluetooth is restricted")
            case .denied:
                Logger.Debug("You are not authorized to use Bluetooth")
            case .allowedAlways:
                break
            @unknown default:
                Logger.Debug("Unexpected authorization")
            }
        case .unsupported:
            Logger.Debug("[BLUETOOTH UNSUPPORTED]")
        case .unknown:
            Logger.Debug("[BLUETOOTH UNKNOWN ERROR]")
        @unknown default:
            Logger.Debug("[BLUETOOTH UNKNOWN ERROR]")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheralBroadCastSubject.send(BluetoothAdvertisementPacket(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI))
        foundPeripherals[peripheral.identifier.uuidString] = peripheral
        peripheralsSubject.send(foundPeripherals)
        
//        Logger.Debug("[PERIPHERAL: \( peripheral)) ADVERTISEMENT DATA: \(advertisementData) RSSI: \(RSSI.stringValue)")
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Logger.Debug("[CONNECTED TO: \(String(describing: peripheral.name))]")
        
        peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.send(peripheral.state)
        peripheralConnectionSubject.send((.connected, peripheral))
        
        peripheral.discoverServices(peripheralServiceUUIDs)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Logger.Debug("[DISCONNECTED FROM: \(String(describing: peripheral.name))]")

        peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.send(peripheral.state)
        peripheralConnectionSubject.send((.disconnected, peripheral))
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Logger.Debug("[CONNECTION FAILED]")

        peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.send(peripheral.state)
        peripheralConnectionSubject.send((.failedToConnect, peripheral))
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        Logger.Debug("[CONNECTION EVENT \(event)]")

        peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.send(peripheral.state)
    }
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        Logger.Debug("[AUTHORIZATION CHANGED]")

        peripheralMonitors[peripheral.identifier.uuidString]?.stateSubject.send(peripheral.state)
    }
}
