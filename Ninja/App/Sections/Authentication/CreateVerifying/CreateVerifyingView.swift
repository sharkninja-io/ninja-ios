//
//  CreateVerifyingView.swift
//  Ninja
//
//  Created by Martin Burch on 11/16/22.
//

import UIKit

class CreateVerifyingView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var activitySpinner: ActivityWorkingView!
    @IBOutlet var continueButton: UIButton!
    
    private var unVerifiedText = "Verifying..., please hold on a few seconds."
    private var verifiedText = "Your account has been verified!"
    
    var isVerified: Bool = false {
        didSet {
            titleLabel.text = isVerified ? verifiedText : unVerifiedText
            continueButton.isHidden = !isVerified
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = unVerifiedText
        continueButton.isHidden = true
        continueButton.setTitle("CONTINUE", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        continueButton.setStyle(.primaryButton)
    }
}
