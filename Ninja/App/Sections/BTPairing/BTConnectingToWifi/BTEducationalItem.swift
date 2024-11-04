//
//  BTEducationalItem.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/3/23.
//

import UIKit

struct BTEducationalItem {
    var title: String
    var info: String
    var image: UIImage?
    
    // TODO: Final images
    static let firstErorrItems: [BTEducationalItem] = [
        BTEducationalItem(
            title: "1. Reset your Grill",
            info: "Turn off your Grill pressing the button",
            image: ImageAssetLibrary.img_grill_start_button.asImage()
        ),
        BTEducationalItem(
            title: "2. Cycle the Wi-Fi on your mobile device.",
            info: "Turn off Wi-Fi on your mobile device. Wait 10 seconds, then turn it back on and connect to your network.",
            image: ImageAssetLibrary.img_iphone_wifi.asImage()
        )
    ]
    
    static let persistentErrorItems: [BTEducationalItem] = [
        BTEducationalItem(
            title: "1. Forgot password:",
            info: "Try checking the back of your router or contact someone who may know it."
        ),
        BTEducationalItem(
            title: "2. Server Issue:",
            info: "Make sure your network is not a VPN or proxy server."
        ),
        BTEducationalItem(
            title: "3. Other:",
            info: "If you’re having internet issues with other products in your home, contact your internet service provider."
        )
    ]
}
