//
//  BTLEWifiJoinStatus.swift
//  Ninja
//
//  Created by Martin Burch on 1/9/23.
//

import Foundation

struct BTLEWifiJoinStatus {
    var dataType: UInt8 = 0 // needed?
    var size: UInt8 = 0
    var progressPercent: UInt8 = 0
    var status: BTLEWifiStatus = .None
    var errorValue: UInt32 = 0
}
