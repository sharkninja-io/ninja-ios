//
//  LoginFormView.swift
//  Ninja
//
//  Created by Martin Burch on 9/9/22.
//

import UIKit

class LoginFormView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var messageBlock: MessageBlockView!
    @IBOutlet var emailWrapper: TextFieldWrapperView!
    @IBOutlet var passwordWrapper: PasswordWrapperView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var noAccountLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Good to see you again!"
        descriptionLabel.text = "Log in with your Ninja account to start."
        emailWrapper.titleLabel.text = "EMAIL"
        emailWrapper.placeholder = "Enter your email"
        passwordWrapper.titleLabel.text = "PASSWORD"
        passwordWrapper.placeholder = "Enter your password"
        noAccountLabel.text = "Don't have an account?"
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.isEnabled = false
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        forgotPasswordButton.setAttributedTitle(NSAttributedString(string: "Forgot your password?", attributes: underlineAttribute), for: .normal)
        signUpButton.setAttributedTitle(NSAttributedString(string: "Sign Up here", attributes: underlineAttribute), for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        descriptionLabel.setStyle(.authSubtitleLabel)
        emailWrapper.setStyle(textFieldStyle: .emailTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        passwordWrapper.setStyle(textFieldStyle: .passwordTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        loginButton.setStyle(.primaryButton)
        forgotPasswordButton.setStyle(.accentedLinkButton)
        noAccountLabel.setStyle(.authSubtitleLabel)
        signUpButton.setStyle(.accentedLinkButton)
    }
    
    func showLoginError() {
        emailWrapper.showMessage(message: "This email/password combination is invalid. Please try again.", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func showExistingAccountInfo(duration: TimeInterval = 0.2) {
        messageBlock.isError = false
        messageBlock.text = "Do you know that you can use your Shark|Ninja account to log in?"
        messageBlock.showMessage()
    }
    
    func showExistingAccountError(duration: TimeInterval = 0.2) {
        messageBlock.text = "Shark|Ninja account is already associated with this email."
        messageBlock.isError = true
        messageBlock.showMessage()
    }
    
    func showPasswordReset(duration: TimeInterval = 0.2) {
        messageBlock.text = "Your password was reset successfully!"
        messageBlock.isError = false
        messageBlock.showMessage()
    }
    
    func fadeError(duration: TimeInterval = 2) {
        messageBlock.hideMessage()
    }
}
