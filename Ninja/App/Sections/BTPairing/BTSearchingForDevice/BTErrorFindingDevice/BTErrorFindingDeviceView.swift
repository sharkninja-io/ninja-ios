//
//  ErrorFindingGrillView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/27/22.
//

import UIKit

class BTErrorFindingDeviceView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var tryAgainButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Ooopss... There was a problem finding your Grill. Please try again!"
        headerLabel.text = "Activate discovery mode"
        detailLabel.text = "On the grill, press and hold the dial for 3-5 seconds to activate discovery mode. You have successfully paired when the Bluetooth icon has transitioned from flashing to solid white."
        
        tryAgainButton.setTitle("Try Again".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        titleLabel.setStyle(.pairingTitleLabel)
        headerLabel.setStyle(.pairingPageTitleLabel)
        detailLabel.setStyle(.pairingLightestInfoLabel)
        
        tryAgainButton.setStyle(.primaryButton)
    }
}
