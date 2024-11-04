//
//  DeclinedPermissionView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class LocalNetworkPermissionDeclinedView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var continueContainerView: UIView!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        pageTitleLabel.text = "CONNECTION TO APPLIANCE"
        titleLabel.text = "Whoops! You declined permission for Ninja ProConnect to access your local area network."
        infoLabel.text = """
        Please go to your mobile settings to grant access.
        1. Open your mobile device's settings
        2. Select Privacy
        3. Select Local Network
        4. Look for the Ninja ProConnect app and
           toggle on to grant permission
        5. Return to the Ninja ProConnect app
        """
        imageView.image = ImageAssetLibrary.img_screen_local_network.asImage()
        continueButton.setTitle("GO TO SETTINGS", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        self.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        continueContainerView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        pageTitleLabel.setStyle(.pairingPageTitleLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        infoLabel.setStyle(.pairingLargestInfoLabel)
        continueButton.setStyle(.primaryButton)
    }
}
