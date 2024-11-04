//
//  PairingPreparationItem.swift
//  Ninja
//
//  Created by Martin Burch on 11/30/22.
//

import UIKit

struct PairingPreparationItem {
    static let items: [PairingPreparationItem] = [
        PairingPreparationItem(
            title: "Plug-in your Grill",
            info: "Plug unit in to proper 3-prong GFCI outlets only.",
            buttonText: "More info",
            image: ImageAssetLibrary.img_american_plug.asImage(),
            buttonViewController: PlugInInfoViewController()
        ),
        PairingPreparationItem(
            title: "Turn on your Grill",
            info: "Press the power button to turn your Grill on.",
            buttonText: "More info",
            image: ImageAssetLibrary.img_grill_start_button.asImage(),
            buttonViewController: PressStartInfoViewController()
        ),
        PairingPreparationItem(
            title: "Connect the app to your Grill",
            info: "Press and hold the dial for 3-5 seconds on the Grill, to activate the discovery mode. Once bluetooth icon has transition from flashing to solid white you have successfully paired.",
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
