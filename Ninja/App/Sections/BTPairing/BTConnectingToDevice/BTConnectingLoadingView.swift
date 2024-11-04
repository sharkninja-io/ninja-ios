//
//  BTConnectingLoadingView.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/6/23.
//

import UIKit

class BTConnectingLoadingView: BaseXIBView {
    
    @IBOutlet var pageIndicator: PageIndicator!
    @IBOutlet var activityWorking: ActivityWorkingView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        
        pageIndicator.pageTitleLabel.text = "Connect To Grill".uppercased()
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
    
    func complete(_ completion: (() -> Void)? = nil) {
        titleLabel.text = "Great! We are going to be good friends!"
        subTitleLabel.text = ""
        activityWorking.complete(completion: completion)
    }
}
