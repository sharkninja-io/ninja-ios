//
//  PairGrillView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PairGrillHotspotView: BaseXIBView {
    
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var activityWorking: ActivityWorkingView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        pageIndicator.pageTitleLabel.text = "PAIRING PREPARATION"
        titleLabel.text = "This might take a moment."
        subTitleLabel.text = "Please bear with me!"
        continueButton.setTitle("Contine".uppercased(), for: .normal)
        continueButton.isHidden = true
    }

    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        subTitleLabel.setStyle(.pairingLargestInfoLabel)
        continueButton.setStyle(.primaryButton)
    }
    
    func start() {
        activityWorking.start()
    }
    
    func complete(completion: (() -> Void)? = nil) {
        titleLabel.text = "We are connected to your Grill, now let's pair to Wi-Fi"
        subTitleLabel.text = ""
        activityWorking.complete(completion: completion)
    }
}
