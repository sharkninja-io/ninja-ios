//
//  BTLEWifiStatus.swift
//  Ninja
//
//  Created by Martin Burch on 1/9/23.
//

import Foundation

enum BTLEWifiStatus: UInt8 {
    case None = 0
    case AP = 1
    case Connecting = 2
    case Connected = 3
    case Error = 4
    case Count = 5
}
