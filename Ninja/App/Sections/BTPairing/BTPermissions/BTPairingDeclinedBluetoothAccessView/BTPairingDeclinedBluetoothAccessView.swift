//
//  BTPairingDeclinedBluetoothAccessView.swift
//  Ninja
//
//  Created by Rahul Sharma on 12/27/22.
//

import UIKit

class BTPairingDeclinedBluetoothAccessView: BaseXIBView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var continueContainerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()


        pageTitleLabel.text = "Connection to grill".uppercased()
        titleLabel.text = "Whoops! You declined permission for Ninja ProConnect to access your Bluetooth!"
        imageView.image = ImageAssetLibrary.img_iphone_BT.asImage()
        imageView.contentMode = .scaleAspectFit
        
        continueButton.setTitle("Go To Settings".uppercased(), for: .normal)
        
        tableView.register(BTPairingDeclinedBluetoothAccessViewCell.self, forCellReuseIdentifier: BTPairingDeclinedBluetoothAccessViewCell.VIEW_ID)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        pageTitleLabel.setStyle(.pairingPageTitleSmallLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        continueContainerView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        continueButton.setStyle(.primaryButton)
    }
}

