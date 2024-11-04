//
//  BTPermissionsView.swift
//  Ninja
//
//  Created by Martin Burch on 12/21/22.
//

import UIKit

class BTPermissionsView: BaseXIBView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var continueContainerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageIndicator: PageIndicator!
    
    override func setupViews() {
        super.setupViews()
        
        pageIndicator.pageTitleLabel.text = "REQUESTING PERMISSIONS"
        titleLabel.text = "Please allow permissions to connect to your Grill."
        descriptionLabel.text = "Select OK / Join to accept the permission prompts. These prompts must be accepted for the app to connect to your Grill."
        imageView.image = ImageAssetLibrary.img_screen_cancel_join.asImage()
        imageView.contentMode = .scaleAspectFit
        
        continueButton.setTitle("NEXT", for: .normal)
        continueButton.isEnabled = false 
        
        tableView.register(BTPermissionsTableViewCell.self, forCellReuseIdentifier: BTPermissionsTableViewCell.VIEW_ID)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false 
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        descriptionLabel.setStyle(.pairingInfoLabel)
        continueContainerView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        continueButton.setStyle(.primaryButton)
    }
    
    func setBluetoothEnabled() {
        // TODO: - fix
        (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BTPermissionsTableViewCell)?.isEnabled = true
    }
}

