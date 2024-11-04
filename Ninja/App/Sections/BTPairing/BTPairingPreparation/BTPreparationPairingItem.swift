//
//  PairingPreparationItem.swift
//  Ninja
//
//  Created by Martin Burch on 11/30/22.
//

import UIKit

struct BTPairingPreparationItem {
    static let items: [BTPairingPreparationItem] = [
        BTPairingPreparationItem(
            title: "1. Plug-in your Grill",
            info: "Plug unit in to proper 3-prong GFCI outlets only.",
            buttonText: "More info",
            image: ImageAssetLibrary.img_american_plug.asImage(),
            buttonViewController: BTPlugInInfoViewController()
        ),
        BTPairingPreparationItem(
            title: "2. Turn on your Grill",
            info: "Press the power button to turn your Grill on.",
            buttonText: "More info",
            image: ImageAssetLibrary.img_grill_start_button.asImage(),
            buttonViewController: BTPressStartInfoViewController()
        ),
        BTPairingPreparationItem(
            title: "3. Connect the app to your Grill",
            info: "\u{2022} Press and hold the dial for 3-5 seconds until you hear an audible beep.\n\u{2022} Press NEXT button below to select your Grill.",
            buttonText: "More info",
            image: ImageAssetLibrary.img_outdoor_pro_grill.asImage(),
            buttonViewController: nil,
            important: true
        ),
    ]
        
    var title: String
    var info: String
    var buttonText: String
    var image: UIImage?
    var buttonViewController: UIViewController?
    var important: Bool = false
}
