//
//  PressStartInfo.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PressStartInfoView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var dismissButton: UIButton!

    override func setupViews() {
        super.setupViews()
        
        pageTitleLabel.text = "Turn on your appliance"
        titleLabel.text = "Press the Start button on your Grill"
        descriptionLabel.text = "Press the rounded Start/Stop button until the screen lights up"
        infoImage.image = ImageAssetLibrary.img_grill_closed.asImage()
        
        dismissButton.setTitle("Got it", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        pageTitleLabel.setStyle(.pairingPageTitleLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        descriptionLabel.setStyle(.pairingLargeInfoLabel)
        dismissButton.setStyle(.primaryButton)
    }
}
