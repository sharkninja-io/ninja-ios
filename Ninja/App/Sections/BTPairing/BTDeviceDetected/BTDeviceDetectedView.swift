//
//  BTDeviceDetectedView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/28/22.
//

import UIKit

class BTDeviceDetectedView: BaseXIBView {
    
    @IBOutlet var pageIndicatorView: PageIndicator!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        pageIndicatorView.pageTitleLabel.text = "Connect to Grill".uppercased()
        
        titleLabel.text = "Grill detected"
        subtitleLabel.text = "Choose your Grill to start the setup process."
        
        collectionView.register(BTApplianceCollectionViewCell.self, forCellWithReuseIdentifier: BTApplianceCollectionViewCell.VIEW_ID)
        collectionView.backgroundColor = .clear
        
        continueButton.setTitle("Continue".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        subtitleLabel.setStyle(.pairingLargestInfoNormalLabel)        
        continueButton.setStyle(.primaryButton)
    }
}
