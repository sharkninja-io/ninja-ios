//
//  ActivateDiscoveryInfoView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class ActivateDiscoveryInfoView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var dismissButton: UIButton!

    override func setupViews() {
        super.setupViews()
        
        pageTitleLabel.text = "Connect the app to your Grill"
        titleLabel.text = "Activate discovery mode on the Grill"
        descriptionLabel.text = "Please hold the mode button for three seconds to activate discovery mode"
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
