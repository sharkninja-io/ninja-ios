//
//  BTWifiSelectionView.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/3/23.
//

import Foundation

import UIKit

class BTWifiSelectionView: BaseXIBView {
    
    @IBOutlet var wifiTipsButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityWorkingView: ActivityWorkingView!
    
    override func setupViews() {
        super.setupViews()
        
        activityWorkingView.overlayColor = .clear
        
        tableView.register(BTWifiSelectionViewCell.self, forCellReuseIdentifier: BTWifiSelectionViewCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

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
    
    func setSpinner(shouldShow: Bool) {
        if shouldShow {
            activityWorkingView.start()
        }
        tableView.isUserInteractionEnabled = !shouldShow
        activityWorkingView.isHidden = !shouldShow
        activityWorkingView.layer.zPosition = shouldShow ? 10 : -10
        if !shouldShow {
            activityWorkingView.stop()
        }
    }
}
