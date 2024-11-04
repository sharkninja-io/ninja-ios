//
//  BTPromptToConnectWifiView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/29/22.
//

import UIKit

class BTPromptToConnectWifiView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
                
        titleLabel.text = "Our connection can be stronger!"
        detailLabel.text = "By pairing with WiFi, you can control your grill anywhere, so long as there’s an internet connection."
        startButton.setTitle("Start Pairing Wifi".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        titleLabel.setStyle(.pairingWhiteOverlayTitleLabel)
        detailLabel.setStyle(.wifiPairingWhiteOverlayInfoLabel)
        startButton.setStyle(.destructiveTertiaryButton)
    }
    
}
