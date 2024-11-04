//
//  PlugInInfoView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PlugInInfoView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var item1Icon: UIImageView!
    @IBOutlet var item2Icon: UIImageView!
    @IBOutlet var item1Label: UILabel!
    @IBOutlet var item2Label: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var dismissButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        pageTitleLabel.text = "Plug-in your appliance"
        titleLabel.text = "Plug unit in to proper 3-prong GFCI outlets only."
        descriptionLabel.text = "If you require an extension cord it must be:"
        item1Label.text = "25ft max length, no less than 14 gauge OR 50ft, no less than 12 gauge."
        item2Label.text = "Suitable for outdoor use."
        item1Icon.image = IconAssetLibrary.ico_list_circle.asImage()
        item2Icon.image = IconAssetLibrary.ico_list_circle.asImage()
        infoImage.image = ImageAssetLibrary.img_plugin_device.asImage()
        
        dismissButton.setTitle("Got it", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        pageTitleLabel.setStyle(.pairingPageTitleLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        descriptionLabel.setStyle(.pairingLargeInfoLabel)
        item1Label.setStyle(.pairingLargeInfoLabel)
        item2Label.setStyle(.pairingLargeInfoLabel)
        dismissButton.setStyle(.primaryButton)
        item1Icon.tintColor = ColorThemeManager.shared.theme.primaryAccentColor
        item2Icon.tintColor = ColorThemeManager.shared.theme.primaryAccentColor
    }
}
