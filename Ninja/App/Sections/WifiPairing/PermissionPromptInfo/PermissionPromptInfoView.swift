//
//  PermissionPromptInfoView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PermissionPromptInfoView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var continueContainerView: UIView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var pageIndicator: PageIndicator!
    
    override func setupViews() {
        super.setupViews()
        
        pageIndicator.pageTitleLabel.text = "REQUESTING PERMISSIONS"
        titleLabel.text = "You will need to accept the permission prompts so the app can connect to your Grill."
        descriptionLabel.text = "Select OK / Join to accept the permission prompts. These prompts must be accepted for the app to connect to your Grill."
        infoLabel.text = "If you select Don't Allow / Cancel, the app will not be able to access your Grill!"
        imageView.image = ImageAssetLibrary.img_screen_cancel_join.asImage()
        continueButton.setTitle("NEXT", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        descriptionLabel.setStyle(.pairingInfoLabel)
        infoLabel.setStyle(.pairingInfoLabel)
        continueContainerView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        continueButton.setStyle(.primaryButton)
    }
}
