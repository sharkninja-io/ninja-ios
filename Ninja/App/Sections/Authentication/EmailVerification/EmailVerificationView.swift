//
//  EmailVerificationView.swift
//  Ninja
//
//  Created by Martin Burch on 9/9/22.
//

import UIKit

class EmailVerificationView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var startOverButton: UIButton!
    @IBOutlet var messageBlock: MessageBlockView!

    var emailAddress: String = "your email" {
        didSet {
            descriptionLabel.text = "We sent an email to \(emailAddress). Open the email and tap Verify to proceed."
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "We're almost there!"
        descriptionLabel.text = "We sent an email to \(emailAddress). Open the email and tap Verify to proceed."
        descriptionLabel.numberOfLines = 0
        resendButton.setTitle("RESEND EMAIL", for: .normal)
        startOverButton.setTitle("Edit Email".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        descriptionLabel.setStyle(.authSubtitleLabel)
        resendButton.setStyle(.primaryButton)
        startOverButton.setStyle(.secondaryButton)

    }
    
    func showAccountNotVerifiedError(duration: TimeInterval = 0.2) {
        messageBlock.text = "Your account is not verified yet. Please check your spam folder."
        messageBlock.isError = true
        messageBlock.showMessage()
    }
    
    func fadeError(duration: TimeInterval = 2) {
        messageBlock.hideMessage()
    }
}
