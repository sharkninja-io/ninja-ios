//
//  PairGrillPersistentFailureView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PairGrillPersistentFailureView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tipContainer: UIView!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var supportButton: UIButton!

    override func setupViews() {
        super.setupViews()
        
        tableView.register(PairGrillPersistentFailureCell.self, forCellReuseIdentifier: PairGrillPersistentFailureCell.VIEW_ID)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = ColorThemeManager.shared.theme.grey02
        tableView.backgroundColor = .clear

        tipContainer.layer.cornerRadius = 16
        tipContainer.layer.shadowOpacity = 0.5
        tipContainer.layer.shadowOffset = .zero
        tipContainer.layer.shadowRadius = 2
        tipLabel.text = " Bot Connection Tips"
        tipLabel.attachImage(IconAssetLibrary.ico_lightbulb.asImage() ?? UIImage(),
                          size: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))

        pageTitleLabel.text = "CONNECTION TIPS"
        titleLabel.text = "Hmm... something is still not working. Don't worry! Here are some other things you can try."
        continueButton.setTitle("TRY AGAIN", for: .normal)
        supportButton.setTitle("CUSTOMER SUPPORT", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        tipContainer.layer.shadowColor = ColorThemeManager.shared.theme.grey01.cgColor
        pageTitleLabel.setStyle(.pairingPageTitleSmallLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        tipLabel.setStyle(.pairingPageTitleLabel)
        continueButton.setStyle(.primaryButton)
        supportButton.setStyle(.secondaryButton)
    }
}
