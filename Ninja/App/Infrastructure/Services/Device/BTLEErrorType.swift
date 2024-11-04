//
//  BTLEErrorType.swift
//  Ninja
//
//  Created by Martin Burch on 2/1/23.
//

import Foundation

enum BTLEErrorType: UInt8 {
    case NoError = 0
    case NoNetwork = 1
    case ConnectionFailed = 2
    case WrongPassword = 3
    case FourWayHandshakeTimeout = 4
    case DHCPFailed = 5
    case Unknown = 6
}
