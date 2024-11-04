//
//  ForgotPasswordView.swift
//  Ninja
//
//  Created by Martin Burch on 9/9/22.
//

import UIKit

class ForgotPasswordView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var emailWrapper: TextFieldWrapperView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var noAccountLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!

    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Can't login?"
        descriptionLabel.text = "We'll email you instructions to reset your password."
        emailWrapper.titleLabel.text = "EMAIL"
        emailWrapper.placeholder = "Enter your email"
        continueButton.setTitle("RESET PASSWORD", for: .normal)
        continueButton.isEnabled = false
        noAccountLabel.text = "Don't have an account?"
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        signUpButton.setAttributedTitle(NSAttributedString(string: "Sign Up here", attributes: underlineAttribute), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        descriptionLabel.setStyle(.authSubtitleLabel)
        emailWrapper.setStyle(textFieldStyle: .emailTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        continueButton.setStyle(.primaryButton)
        noAccountLabel.setStyle(.authSubtitleLabel)
        signUpButton.setStyle(.accentedLinkButton)
    }
    
    func showEmailError() {
        // TODO: // toast, errorField, dialog???
    }
    
    func showRequestError() {
        // TODO: // toast, errorField, dialog???
    }
}
