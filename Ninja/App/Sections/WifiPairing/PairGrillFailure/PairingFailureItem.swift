//
//  PairingFailureItem.swift
//  Ninja
//
//  Created by Martin Burch on 12/5/22.
//

import UIKit

struct PairingFailureItem {
    
    static let applianceItems: [PairingFailureItem] = [
        PairingFailureItem(
            title: "1. Reset your Grill.",
            info: "Turn off your Grill presing the button.",
            image: ImageAssetLibrary.img_grill_start_button.asImage()
        ),
        PairingFailureItem(
            title: "2. Cycle the Wi-Fi on your mobile device.",
            info: "Turn off Wi-Fi on your mobile device. Wait 10 seconds, then turn it back on and connect to your network.",
            image: ImageAssetLibrary.img_iphone_wifi.asImage()
        )
    ]
    
    var title: String
    var info: String
    var image: UIImage? = nil
    
}
