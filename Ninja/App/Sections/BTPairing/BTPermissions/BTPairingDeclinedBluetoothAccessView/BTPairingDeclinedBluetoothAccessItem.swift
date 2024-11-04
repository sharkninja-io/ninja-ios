//
//  BTPairingDeclinedBluetoothAccessItem.swift
//  Ninja
//
//  Created by Rahul Sharma on 12/28/22.
//

import Foundation

struct BTPairingDeclinedBluetoothAccessItem {
    static let items: [BTPairingDeclinedBluetoothAccessItem] = [
       BTPairingDeclinedBluetoothAccessItem(index: 1, title: "Open your mobile device's settings"),
       BTPairingDeclinedBluetoothAccessItem(index: 2, title: "Select Privacy"),
       BTPairingDeclinedBluetoothAccessItem(index: 3, title: "Look for the Ninja ProConnect app and toggle on to grant bluetooth permission"),
       BTPairingDeclinedBluetoothAccessItem(index: 4, title: "Return to the Ninja ProConnect app")

    ]
        
    var index: Int
    var title: String
}
