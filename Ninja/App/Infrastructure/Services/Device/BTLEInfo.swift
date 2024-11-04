//
//  BTLEInfo.swift
//  Ninja
//
//  Created by Martin Burch on 1/26/23.
//

import Foundation

struct BTLEInfo {
    var dataType: UInt8 = 0 // needed?
    var size: UInt8 = 0
    var dsn: String? = ""
    var isOnboardedToWifi: Bool = false
    var wifiConnectionStatus: UInt8 = 0
    var wifiRSSI: Int16 = 0
    var verWifi: UInt32 = 0
    var verSTM32: UInt32 = 0
    var verBT: UInt32 = 0
}
