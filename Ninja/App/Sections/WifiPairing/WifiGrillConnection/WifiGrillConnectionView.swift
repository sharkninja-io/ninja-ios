//
//  WifiGrillSetupView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class WifiGrillConnectionView: BaseXIBView {
    
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var activityWorking: ActivityWorkingView!
    @IBOutlet var continueButton: UIButton!

    override func setupViews() {
        super.setupViews()
        
        pageIndicator.pageTitleLabel.text = "CONNECTING TO WIFI"
        titleLabel.text = "This may take a few minutes"
        infoLabel.text = "Please keep this screen open and live until the connection has completed."
        continueButton.setTitle("Contine".uppercased(), for: .normal)
        continueButton.isHidden = true
    }

    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        infoLabel.setStyle(.pairingLargestInfoLabel)
        continueButton.setStyle(.primaryButton)
    }
    
    func start() {
        activityWorking.start()
    }
    
    func complete(completion: (() -> Void)? = nil) {
        titleLabel.text = "All set! We are going to be good friends!"
        infoLabel.text = ""
        activityWorking.complete(completion: completion)
    }
}
