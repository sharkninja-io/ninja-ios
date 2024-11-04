//
//  ResetPasswordView.swift
//  Ninja
//
//  Created by Martin Burch on 9/9/22.
//

import UIKit

class ResetPasswordView: BaseXIBView {
    
    let validImage = IconAssetLibrary.ico_checkmark.asImage()
    let invalidImage = IconAssetLibrary.ico_empty.asImage()

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var passwordWrapper: PasswordWrapperView!
    
    @IBOutlet var uppercaseLabel: UILabel!
    @IBOutlet var lowercaseLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var characterCountLabel: UILabel!
    @IBOutlet var uppercaseMark: UIImageView!
    @IBOutlet var lowercaseMark: UIImageView!
    @IBOutlet var numberMark: UIImageView!
    @IBOutlet var characterCountMark: UIImageView!

    @IBOutlet var resetButton: UIButton!
        
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Great!"
        descriptionLabel.text = "Now let's create a new password."
        passwordWrapper.titleLabel.text = "PASSWORD"
        passwordWrapper.placeholder = "Enter your password"
        uppercaseLabel.text = "1 uppercase letter"
        lowercaseLabel.text = "1 lowercase letter"
        numberLabel.text = "1 number"
        characterCountLabel.text = "8 or more characters"
        resetButton.setTitle("RESET PASSWORD", for: .normal)
        resetButton.isEnabled = false
        
        uppercaseMark.contentMode = .center
        lowercaseMark.contentMode = .center
        numberMark.contentMode = .center
        characterCountMark.contentMode = .center
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        descriptionLabel.setStyle(.authSubtitleLabel)
        passwordWrapper.setStyle(textFieldStyle: .passwordTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        uppercaseLabel.setStyle(.authInfoLabel)
        lowercaseLabel.setStyle(.authInfoLabel)
        numberLabel.setStyle(.authInfoLabel)
        characterCountLabel.setStyle(.authInfoLabel)
        resetButton.setStyle(.primaryButton)
    }
    
    func updatePasswordRequirements() {
        uppercaseMark.image = passwordWrapper.textField.text?.containsUppercaseCharacter() ?? false ? validImage : invalidImage
        lowercaseMark.image = passwordWrapper.textField.text?.containsLowercaseCharacter() ?? false ? validImage : invalidImage
        numberMark.image = passwordWrapper.textField.text?.containsDigit() ?? false ? validImage : invalidImage
        characterCountMark.image = (passwordWrapper.textField.text?.count ?? 0) >= 8 ? validImage : invalidImage
    }
    
    func showResetError() {
        // TODO: // error field, toast, dialog???
    }
    
    func showInvalidFieldsError() {
        // TODO: // error field, toast, dialog???
    }
}
