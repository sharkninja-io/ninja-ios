//
//  DeviceBTPairingService+DataConversion.swift
//  Ninja
//
//  Created by Martin Burch on 1/6/23.
//

import Foundation

// MARK: DATA CONVERSION
extension DeviceBTPairingService {
    
    func getDataType(data: Data) -> BTLEDataType {
        let dataType = Array(data).first
        guard let dataType = dataType else { return .Unknown }
        return BTLEDataType(rawValue: dataType) ?? .Unknown
    }
    
    func decodeBTData<T>(data: Data) -> T? {
        switch getDataType(data: data) {
        case .WiFiScanResult:
            return decodeBTWifiConnection(data: data) as? T
        case .WiFiJoinStatus:
            return decodeBTWifiConnectionStatus(data: data) as? T
        default:
            return nil
        }
    }
    
    func decodeBTWifiConnection(data: Data) -> BTLEWifiNetwork? {
        var dataArray = Array(data)
        let dataType = getDataType(data: data)
        guard dataType == BTLEDataType.WiFiScanResult else { return nil }

        var connection = BTLEWifiNetwork()
        connection.dataType = dataArray.removeFirstOrDefault(0)
        connection.size = dataArray.removeFirstOrDefault(0)
        connection.index = UInt16(dataArray.removeFirstOrDefault(0)) | UInt16(dataArray.removeFirstOrDefault(0) << 8)
        connection.totalCount = UInt16(dataArray.removeFirstOrDefault(0)) | UInt16(dataArray.removeFirstOrDefault(0) << 8)
        let ssidBytes = Array(dataArray[0...33])
        connection.ssid = String(bytes: ssidBytes, encoding: .utf8)?.replacingOccurrences(of: "\0", with: "")
        dataArray = Array(dataArray[34...])
        connection.networkType = dataArray.removeFirstOrDefault(0)
        connection.channel = dataArray.removeFirstOrDefault(0)
        connection.rssi = Int8(bitPattern: dataArray.removeFirstOrDefault(0))
        connection.bars = Int8(bitPattern: dataArray.removeFirstOrDefault(0))
        connection.security = UInt32(dataArray.removeFirstOrDefault(0)) | UInt32(dataArray.removeFirstOrDefault(0) << 8)
                            | UInt32(dataArray.removeFirstOrDefault(0) << 16) | UInt32(dataArray.removeFirstOrDefault(0) << 24)
        connection.bssid = Array(dataArray[0...5])
        
        return connection
    }
    
    func decodeBTWifiConnectionStatus(data: Data) -> BTLEWifiJoinStatus? {
        var dataArray = Array(data)
        let dataType = getDataType(data: data)
        guard dataType == BTLEDataType.WiFiJoinStatus else { return nil }

        var status = BTLEWifiJoinStatus()
        status.dataType = dataArray.removeFirstOrDefault(0)
        status.size = dataArray.removeFirstOrDefault(0)
        status.progressPercent = dataArray.removeFirstOrDefault(0)
        status.status = BTLEWifiStatus(rawValue: dataArray.removeFirstOrDefault(0)) ?? .None
        status.errorValue = UInt32(dataArray.removeFirstOrDefault(0)) | UInt32(dataArray.removeFirstOrDefault(0) << 8)
                            | UInt32(dataArray.removeFirstOrDefault(0) << 16) | UInt32(dataArray.removeFirstOrDefault(0) << 24)

        return status
    }

    func decodeBTInfoResponse(data: Data) -> BTLEInfo? {
        var dataArray = Array(data)
        let dataType = getDataType(data: data)
        guard dataType == BTLEDataType.GrillInfoResponse else { return nil }

        var info = BTLEInfo()
        info.dataType = dataArray.removeFirstOrDefault(0)
        info.size = dataArray.removeFirstOrDefault(0)
        let dsnBytes = Array(dataArray[0...20])
        info.dsn = String(bytes: dsnBytes, encoding: .utf8)?.replacingOccurrences(of: "\0", with: "")
        info.isOnboardedToWifi = dataArray.removeFirstOrDefault(0) > 0
        info.wifiConnectionStatus = dataArray.removeFirstOrDefault(0)
        info.wifiRSSI = Int16(dataArray.removeFirstOrDefault(0)) | Int16(dataArray.removeFirstOrDefault(0) << 8)
        info.verWifi = UInt32(dataArray.removeFirstOrDefault(0)) | UInt32(dataArray.removeFirstOrDefault(0) << 8)
            | UInt32(dataArray.removeFirstOrDefault(0) << 16) | UInt32(dataArray.removeFirstOrDefault(0) << 24)
        info.verSTM32 = UInt32(dataArray.removeFirstOrDefault(0)) | UInt32(dataArray.removeFirstOrDefault(0) << 8)
            | UInt32(dataArray.removeFirstOrDefault(0) << 16) | UInt32(dataArray.removeFirstOrDefault(0) << 24)
        info.verBT = UInt32(dataArray.removeFirstOrDefault(0)) | UInt32(dataArray.removeFirstOrDefault(0) << 8)
            | UInt32(dataArray.removeFirstOrDefault(0) << 16) | UInt32(dataArray.removeFirstOrDefault(0) << 24)

        return info
    }

    func encodeBTWifiScanRequest() -> Data {
        var dataArray: [UInt8] = []
        dataArray.append(BTLEDataType.WiFiScanRequest.rawValue)
        dataArray.append(2)
        return Data(dataArray)
    }
    
    func encodeBTWifiScanResultRequest() -> Data {
        var dataArray: [UInt8] = []
        dataArray.append(BTLEDataType.WiFiScanResult.rawValue)
        dataArray.append(2)
        return Data(dataArray)
    }
    
    func encodeBTWifiScanDone() -> Data {
        var dataArray: [UInt8] = []
        dataArray.append(BTLEDataType.WiFiScanRequestDone.rawValue)
        dataArray.append(2)
        return Data(dataArray)
    }
    
    func encodeBTWifiJoinRequest(ssid: String, pwd: String, token: String) -> Data {
        var dataArray: [UInt8] = []
        
        dataArray.append(BTLEDataType.WiFiJoinRequest.rawValue)
        dataArray.append(2)
        dataArray.append(UInt8(truncatingIfNeeded: token.count))
        dataArray.append(UInt8(truncatingIfNeeded: ssid.count))
        dataArray.append(UInt8(truncatingIfNeeded: pwd.count))
        dataArray.append(contentsOf: token.utf8)
        dataArray.append(contentsOf: ssid.utf8)
        dataArray.append(contentsOf: pwd.utf8)

        return Data(dataArray)
    }
    
    func encodeBTInfoRequest() -> Data {
        var dataArray: [UInt8] = []
        dataArray.append(BTLEDataType.GrillInfoRequest.rawValue)
        dataArray.append(2)
        return Data(dataArray)
    }
    
    static func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

}
