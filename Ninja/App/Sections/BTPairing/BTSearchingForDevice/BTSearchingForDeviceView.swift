//
//  BTSearchingForDeviceView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/23/22.
//

import UIKit

class BTSearchingForDeviceView: BaseXIBView {
    
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var activityWorking: ActivityWorkingView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        
        pageIndicator.pageTitleLabel.text = "PAIRING PREPARATION"
        titleLabel.text = "This might take a moment."
        subTitleLabel.text = "Please bear with me!"
    }

    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        subTitleLabel.setStyle(.pairingLargestInfoLabel)
    }
    
    func start() {
        activityWorking.start()
    }
    
    func stop(completion: (() -> Void)? = nil) {
        activityWorking.complete {
            completion?()
        }
    }
    
    func complete(title: String? = nil, completion: (() -> Void)? = nil) {
        activityWorking.complete(completion: completion)
    }
}
