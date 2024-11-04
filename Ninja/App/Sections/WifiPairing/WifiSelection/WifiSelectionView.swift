//
//  WifiSelectionView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class WifiSelectionView: BaseXIBView {
    
    @IBOutlet var wifiTipsButton: UIButton!
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    override func setupViews() {
        super.setupViews()
        
        tableView.register(WifiSelectionViewCell.self, forCellReuseIdentifier: WifiSelectionViewCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

        pageIndicator.pageTitleLabel.text = "CONNECTING TO WIFI"
        
        titleLabel.text = "Select your Wi-Fi network"
        infoLabel.text = "Make sure the network has at least 2 bars. If the signal is too weak, try moving your Grill closer to the router."
        
        wifiTipsButton.setTitle("I don't see my network", for: .normal)
    }

    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        infoLabel.setStyle(.pairingLargestInfoLabel)
        wifiTipsButton.setStyle(.accentedLinkButton)
        wifiTipsButton.contentHorizontalAlignment = .left
    }
}
