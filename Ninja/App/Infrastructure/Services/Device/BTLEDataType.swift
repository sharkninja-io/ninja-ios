//
//  BLEDataType.swift
//  Ninja
//
//  Created by Martin Burch on 1/9/23.
//

import Foundation

enum BTLEDataType: UInt8 {
    case AuthRequest = 0
    case AuthResponse = 1
    case AuthOK = 2
    case WiFiScanRequest = 3
    case WiFiScanRequestDone = 4
    case WiFiScanResult = 5
    case WiFiJoinRequest = 6
    case WiFiJoinStatus = 7
    case GrillStatusRequest = 8
    case GrillStatusResponse = 9
    case GrillCommand = 10
    case GrillInfoRequest = 11
    case GrillInfoResponse = 12
    
    case Unknown = 255
}
