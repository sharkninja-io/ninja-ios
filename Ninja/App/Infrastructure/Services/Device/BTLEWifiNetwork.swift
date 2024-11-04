//
//  BTLEWifiNetwork.swift
//  Ninja
//
//  Created by Martin Burch on 1/9/23.
//

import Foundation

struct BTLEWifiNetwork: Hashable, Equatable {
    var dataType: UInt8 = 0
    var size: UInt8 = 0
    var index: UInt16 = 0
    var totalCount: UInt16 = 0
    var ssid: String? = nil
    var networkType: UInt8 = 0
    var channel: UInt8 = 0
    var rssi: Int8 = 0
    var bars: Int8 = 0
    var security: UInt32 = 0
    var bssid: [UInt8] = [UInt8](repeating: 0, count: 6)
    var password: String? = nil
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ssid)
    }
    
    static func ==(lt: BTLEWifiNetwork, rt: BTLEWifiNetwork) -> Bool {
        return lt.ssid == rt.ssid
    }
}
