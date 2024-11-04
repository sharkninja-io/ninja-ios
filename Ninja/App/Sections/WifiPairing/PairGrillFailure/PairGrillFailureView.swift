//
//  PairGrillFailureView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PairGrillFailureView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(PairGrillFailureCell.self, forCellReuseIdentifier: PairGrillFailureCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

        pageTitleLabel.text = "CONNECTION TO APPLIANCE"
        titleLabel.text = "Looks like I wasn't able to connect. Let's try something else!"
        continueButton.setTitle("TRY AGAIN", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        pageTitleLabel.setStyle(.pairingPageTitleSmallLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        continueButton.setStyle(.primaryButton)
    }
}
