//
//  PairingPreparationView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PairingPreparationView: BaseXIBView {
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var tableView: UITableView!
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(PairingPreparationCell.self, forCellReuseIdentifier: PairingPreparationCell.VIEW_ID)
        tableView.register(PairingPreparationBottomImageCell.self, forCellReuseIdentifier: PairingPreparationBottomImageCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

        pageIndicator.pageTitleLabel.text = "PAIRING PREPARATION"
        continueButton.setTitle("NEXT", for: .normal)
    }

    override func refreshStyling() {
        super.refreshStyling()
        
        continueButton.setStyle(.primaryButton)
    }
}
