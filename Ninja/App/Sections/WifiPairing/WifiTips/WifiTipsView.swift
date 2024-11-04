//
//  WifiTipsView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class WifiTipsView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(WifiTipsViewCell.self, forCellReuseIdentifier: WifiTipsViewCell.VIEW_ID)
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

        titleLabel.text = "Network Tips"
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingWifiTitleLabel)
        titleLabel.textAlignment = .center
    }
}
