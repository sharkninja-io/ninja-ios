//
//  PairingFailureItem.swift
//  Ninja
//
//  Created by Martin Burch on 12/12/22.
//

import Foundation

extension PairingFailureItem {
    
    static let connectionItems: [PairingFailureItem] = [
        PairingFailureItem(
            title: "1. Reset your Grill.",
            info: "Turn off your Grill presing the power button.",
            image: ImageAssetLibrary.img_grill_start_button.asImage()
        ),
        PairingFailureItem(
            title: "2. Reset your router.",
            info: "Unplug the power cord from the wall (or the back of the router), wait 60 seconds, then plug it back in.",
            image: ImageAssetLibrary.img_wifi_router.asImage()
        ),
    ]
        
}
