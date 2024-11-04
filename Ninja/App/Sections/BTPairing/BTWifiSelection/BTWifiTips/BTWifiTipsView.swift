//
//  BTWifiTipsView.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/3/23.
//

import UIKit

class BTWifiTipsView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(BTWifiTipsCell.self, forCellReuseIdentifier: BTWifiTipsCell.VIEW_ID)
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

        titleLabel.text = "Network Tips".capitalized
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
    }
}
