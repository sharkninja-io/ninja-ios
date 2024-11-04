//
//  CreateAccountFormView.swift
//  Ninja
//
//  Created by Martin Burch on 9/9/22.
//

import UIKit

class CreateAccountFormView: BaseXIBView {
    
    let validImage = IconAssetLibrary.ico_checkmark.asImage()
    let invalidImage = IconAssetLibrary.ico_empty.asImage()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var emailWrapper: TextFieldWrapperView!
    @IBOutlet var passwordWrapper: PasswordWrapperView!
    @IBOutlet var termsCheckbox: Checkbox!
    @IBOutlet var termsLabel: UILabel!
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var privacyCheckbox: Checkbox!
    @IBOutlet var privacyLabel: UILabel!
    @IBOutlet var privacyButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var haveAccountLabel: UILabel!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var messageBlock: MessageBlockView!

    @IBOutlet var uppercaseLabel: UILabel!
    @IBOutlet var lowercaseLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var characterCountLabel: UILabel!
    @IBOutlet var uppercaseMark: UIImageView!
    @IBOutlet var lowercaseMark: UIImageView!
    @IBOutlet var numberMark: UIImageView!
    @IBOutlet var characterCountMark: UIImageView!
    
    override func setupViews() {
        initScrollableXIB(with: Self.VIEW_ID, owner: self)
        
        titleLabel.text = "Welcome!"
        descriptionLabel.text = "Let's create your new Ninja account."
        emailWrapper.placeholder = "Enter your email"
        emailWrapper.titleLabel.text = "EMAIL"
        passwordWrapper.placeholder = "Create a new password"
        passwordWrapper.titleLabel.text = "PASSWORD"
        uppercaseLabel.text = "1 uppercase letter"
        lowercaseLabel.text = "1 lowercase letter"
        numberLabel.text = "1 number"
        characterCountLabel.text = "8 or more characters"
        termsCheckbox.setTitle("", for: .normal)
        termsLabel.text = "I agree to the"
        privacyLabel.text = "I have read and understand the"
        privacyCheckbox.setTitle("", for: .normal)
        haveAccountLabel.text = "Already have an account?"

        uppercaseMark.contentMode = .center
        lowercaseMark.contentMode = .center
        numberMark.contentMode = .center
        characterCountMark.contentMode = .center
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        termsButton.setAttributedTitle(NSAttributedString(string: "Terms & Conditions", attributes: underlineAttribute), for: .normal)
        privacyButton.setAttributedTitle(NSAttributedString(string: "Privacy Notice", attributes: underlineAttribute), for: .normal)
        signInButton.setAttributedTitle(NSAttributedString(string: "Log in", attributes: underlineAttribute), for: .normal)

        continueButton.setTitle("REGISTER NOW", for: .normal)
        continueButton.isEnabled = false
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        descriptionLabel.setStyle(.authSubtitleLabel)
        emailWrapper.setStyle(textFieldStyle: .emailTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        passwordWrapper.setStyle(textFieldStyle: .passwordTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        uppercaseLabel.setStyle(.authInfoLabel)
        lowercaseLabel.setStyle(.authInfoLabel)
        numberLabel.setStyle(.authInfoLabel)
        characterCountLabel.setStyle(.authInfoLabel)
        termsCheckbox.setStyle(.checkboxCenteredButton)
        termsLabel.setStyle(.itemLabel)
        termsButton.setStyle(.linkButton)
        privacyCheckbox.setStyle(.checkboxCenteredButton)
        privacyLabel.setStyle(.authInfoLabel)
        privacyButton.setStyle(.linkButton)
        haveAccountLabel.setStyle(.authSubtitleLabel)
        signInButton.setStyle(.accentedLinkButton)
        continueButton.setStyle(.primaryButton)
    }
    
    func showEmailError() {
        emailWrapper.showMessage(message: "Please enter a valid email address.", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func showEmailSuggestion(domain: String) {
        emailWrapper.showMessage(message: "Did you mean \(domain)?", color: ColorThemeManager.shared.theme.primaryAccentColor)
    }
    
    func showExistingAccountInfo(duration: TimeInterval = 0.2) {
        messageBlock.text = "Do you know that you can use your Shark|Ninja account to log in."
        messageBlock.isError = false
        messageBlock.showMessage()
    }
    
    func fadeError(duration: TimeInterval = 2) {
        messageBlock.hideMessage()
    }

    func hideEmailMessage() {
        emailWrapper.hideMessage()
    }
    
    func updatePasswordRequirements() {
        uppercaseMark.image = passwordWrapper.textField.text?.containsUppercaseCharacter() ?? false ? validImage : invalidImage
        lowercaseMark.image = passwordWrapper.textField.text?.containsLowercaseCharacter() ?? false ? validImage : invalidImage
        numberMark.image = passwordWrapper.textField.text?.containsDigit() ?? false ? validImage : invalidImage
        characterCountMark.image = (passwordWrapper.textField.text?.count ?? 0) >= 8 ? validImage : invalidImage
    }
    
    func showCreationFailedError() {
        // TODO: // toast, errorField, dialog??
    }
}
