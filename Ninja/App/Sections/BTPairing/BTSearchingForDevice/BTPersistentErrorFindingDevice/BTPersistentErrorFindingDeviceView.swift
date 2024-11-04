//
//  BTPersistentErrorView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/27/22.
//

import UIKit

class BTPersistentErrorFindingDeviceView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var connectWithWifiButton: UIButton!
    @IBOutlet var fadeView: UIView!
    
    override func setupViews() {
        super.setupViews()
        
        fadeView.backgroundColor = .black.withAlphaComponent(0.3)
        
        titleLabel.numberOfLines = 0
        detailLabel.numberOfLines = 0
        
        connectWithWifiButton.setTitle("Connect With Wi-Fi".uppercased(), for: .normal)
        
        titleLabel.text = "Oopss... unable to connect with bluetooth"
        detailLabel.text = "Let's try with Wi-Fi, you’ll be able to control your cook from anywhere as long as internet connection is available."
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingWhiteOverlayTitleLabel)
        detailLabel.setStyle(.pairingWhiteOverlayInfoLabel)
        connectWithWifiButton.setStyle(.destructiveTertiaryButton)
    }
}
