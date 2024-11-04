//
//  BTConnectingToWifiView.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/3/23.
//

import UIKit

class BTConnectingToWifiView: BaseXIBView {
    
    @IBOutlet var activityWorking: ActivityWorkingView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var toDashboardButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "This may take a few minutes"
        subTitleLabel.text = "Please, keep this screen open and live until the connection has completed."
        
        toDashboardButton.setTitle("To The Dashboard".uppercased(), for: .normal)
        toDashboardButton.isHidden = true // Only visible upon success
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        subTitleLabel.setStyle(.pairingLargestInfoLabel)
        toDashboardButton.setStyle(.primaryButton)
    }
    
    func start() {
        activityWorking.start()
    }
    
    func stop(_ completion: (() -> Void)? = nil) {
        activityWorking.complete {
            completion?()
        }
    }
    
    func complete(completion: (() -> Void)? = nil) {
        titleLabel.text = "Great! Let's start cooking together."
        subTitleLabel.text = ""
        toDashboardButton.isHidden = false
        activityWorking.complete(completion: completion)
    }
}
