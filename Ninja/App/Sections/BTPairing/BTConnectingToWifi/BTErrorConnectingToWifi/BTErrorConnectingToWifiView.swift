//
//  BTErrorConnectingToWifiView.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/3/23.
//

import UIKit

class BTErrorConnectingToWifiView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tryAgainButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(BTEducationalCell.self, forCellReuseIdentifier: BTEducationalCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear
        
        titleLabel.text = "Connection to Grill".uppercased()
        infoLabel.text = "Looks like I wasn’t able to connect. Let's try something else!"
        
        tryAgainButton.setTitle("Try Again".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingPageTitleSmallLabel)
        infoLabel.setStyle(.pairingTitleLabel)
        
        tryAgainButton.setStyle(.primaryButton)
    }
}
