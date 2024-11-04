//
//  BluetoothPeripheral.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/7/22.
//

import Foundation
import CoreBluetooth
import Combine

enum BluetoothDiscoveryState {
    case NONE
    case SERVICES
    case CHARACTERISTICS(CBService)
    case DESCRIPTORS(CBCharacteristic)
}

class BluetoothPeripheral: NSObject {
    
    let peripheral: CBPeripheral
    
    var stateSubject = CurrentValueSubject<CBPeripheralState, Never>(.disconnected) // Connection state
    var rssiSubject = CurrentValueSubject<NSNumber, Never>(0)
    var characteristicUpdateSubject = PassthroughSubject<CBCharacteristic, Never>()
    var descriptorUpdateSubject = PassthroughSubject<CBDescriptor, Never>()
    var characteristicNotificationStateSubject = PassthroughSubject<CBCharacteristic, Never>()
    var errorSubject = PassthroughSubject<Error, Never>()

    var discoverySubject = CurrentValueSubject<BluetoothDiscoveryState, Never>(.NONE)
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    func findCharacteristic(uuid: String) -> CBCharacteristic? {
        return peripheral.services?.first?.characteristics?.first(where: { $0.uuid.uuidString == uuid })
    }
    
    func truncateData(data: Data) -> Data {
        let maxWriteLength = peripheral.maximumWriteValueLength (for: .withResponse)
        if maxWriteLength < data.count {
            var rawPacket: [UInt8] = []
            data.copyBytes(to: &rawPacket, count: maxWriteLength)
            return Data(bytes: &rawPacket, count: maxWriteLength)
        }
        return data
    }
}

extension BluetoothPeripheral: CBPeripheralDelegate {
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        // TODO: // name changed???
    }

    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        // Did open L2CAP channel
    }

    // MARK: SERVICES
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        Logger.Debug("PERIPHERAL: \(String(describing: peripheral.name)) SERVICES: \(services.count)")
        discoverySubject.send(.SERVICES)
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        // service modified
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        // service discovery completed
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        Logger.Debug("SERVICE: \(service.description) CHARACTERISTICS: \(characteristics.count)")
        
        for characteristic in characteristics {
            peripheral.discoverDescriptors(for: characteristic)
            if characteristic.properties.contains(.indicate) {
                peripheral.setNotifyValue(true, for: characteristic)
                Logger.Debug("CHARACTERISTIC (NOTIFIABLE): \(characteristic.debugDescription)")
            }
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
        }
        discoverySubject.send(.CHARACTERISTICS(service))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else { return }
        
        Logger.Debug("CHARACTERISTIC: \(characteristic.debugDescription) DESCRIPTORS: \(descriptors.count)")
        
        for descriptor in descriptors {
            peripheral.readValue(for: descriptor)
        }
        discoverySubject.send(.DESCRIPTORS(characteristic))
    }

    // MARK: RSSI
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            Logger.Error("ERROR-RSSI: \(error.localizedDescription)")
            errorSubject.send(error)
        } else {
            Logger.Debug("DATA-RSSI: \(RSSI)")
            rssiSubject.send(RSSI)
        }
    }

    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        // succeeded
    }

    // MARK: VALUES
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            Logger.Error("ERROR-WRITE: \(error.localizedDescription) \(characteristic.debugDescription)")
            errorSubject.send(error)
        } else {
            Logger.Debug("DATA-WRITE: \(characteristic.debugDescription)")
            characteristicUpdateSubject.send(characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            Logger.Error("ERROR-UPDATE: \(error.localizedDescription) \(characteristic.debugDescription)")
            errorSubject.send(error)
        } else {
            Logger.Debug("DATA-UPDATE: \(characteristic.debugDescription)")
            characteristicUpdateSubject.send(characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            Logger.Error("ERROR-NOTIFY: \(error.localizedDescription)")
            errorSubject.send(error)
        } else {
            Logger.Debug("DATA-NOTIFY: \(characteristic.debugDescription)")
            characteristicNotificationStateSubject.send(characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if let error = error {
            errorSubject.send(error)
        } else {
            descriptorUpdateSubject.send(descriptor)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if let error = error {
            Logger.Error("ERROR-DESCRIPTOR: \(error.localizedDescription)")
            errorSubject.send(error)
        } else {
            Logger.Debug("DESCRIPTOR-UPDATE: \(descriptor.debugDescription)")
            Logger.Debug("DESCRIPTOR-UPDATE-CHARACTERISTIC: \(String(describing: descriptor.characteristic))")
            descriptorUpdateSubject.send(descriptor)
        }
    }

    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        // TODO: // Ready to continue???
    }
    
}
