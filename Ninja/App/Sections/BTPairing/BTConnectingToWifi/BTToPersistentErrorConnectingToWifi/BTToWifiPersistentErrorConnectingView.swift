//
//  BTPersistentErrorConnectingToWifiView.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/4/23.
//

import UIKit

class BTToWifiPersistentErrorConnectingView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tryAgainButton: UIButton!
    @IBOutlet var contactSupportButton: UIButton!

    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(BTEducationalCell.self, forCellReuseIdentifier: BTEducationalCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear
        
        titleLabel.text = "Wi-Fi Tips".uppercased()
        infoLabel.text = "Hmm... something is still not working. Don't worry! Here are some other things you can try."
        
        tryAgainButton.setTitle("Try Again".uppercased(), for: .normal)
        contactSupportButton.setTitle("Customer Support".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingPageTitleSmallLabel)
        infoLabel.setStyle(.pairingTitleLabel)
        
        tryAgainButton.setStyle(.primaryButton)
        contactSupportButton.setStyle(.secondaryButton)
    }
}
