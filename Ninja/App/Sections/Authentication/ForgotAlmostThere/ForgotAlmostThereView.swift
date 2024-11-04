//
//  ForgotAlmostThereView.swift
//  Ninja
//
//  Created by Martin Burch on 11/16/22.
//

import UIKit

class ForgotAlmostThereView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var didntReceiveLabel: UILabel!
    @IBOutlet var resendButton: UIButton!
        
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "We're almost there!"
        descriptionLabel.text = "We sent you an email with instructions on how to reset your password. Open the email and tap the Reset Password link to get started."
        didntReceiveLabel.text = "Didn't get the email? Check your spam folder. If the message still hasn't arrived after a few minutes, tap the button below and we will re-send it."
        resendButton.setTitle("RESEND EMAIL", for: .normal)
        resendButton.setImage(IconAssetLibrary.system_arrow_counterclockwise.asSystemImage(), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        descriptionLabel.setStyle(.authSubtitleLabel)
        didntReceiveLabel.setStyle(.authInfoLabel)
        resendButton.setStyle(.secondaryButton)
    }
}
