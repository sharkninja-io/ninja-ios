//
//  ChangePasswordView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/8/22.
//

import UIKit

class ChangePasswordView: BaseView {
    @UsesAutoLayout var scrollView = UIScrollView()
    @UsesAutoLayout var contentView = UIView()
    
    @UsesAutoLayout var titleLabel = UILabel()
    
    @UsesAutoLayout var oldPasswordWrapper = PasswordWrapperView()
    @UsesAutoLayout var newPasswordWrapper = PasswordWrapperView()
    @UsesAutoLayout var confirmPasswordWrapper = PasswordWrapperView()
    
    // Validation objects
    let validImage = IconAssetLibrary.ico_checkmark.asImage()
    let invalidImage = IconAssetLibrary.ico_empty.asImage()
    
    @UsesAutoLayout var uppercaseMark = UIImageView()
    @UsesAutoLayout var uppercaseLabel = UILabel()

    @UsesAutoLayout var lowercaseMark = UIImageView()
    @UsesAutoLayout var lowercaseLabel = UILabel()
    
    @UsesAutoLayout var characterCountMark = UIImageView()
    @UsesAutoLayout var characterCountLabel = UILabel()
    
    @UsesAutoLayout var numberMark = UIImageView()
    @UsesAutoLayout var numberLabel = UILabel()
    
    // Buttons
    @UsesAutoLayout var changePasswordButton = UIButton()
    
    override func setupViews() {
        scrollView.pinTo(superView: self, withContentView: contentView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(oldPasswordWrapper)
        contentView.addSubview(newPasswordWrapper)
        contentView.addSubview(confirmPasswordWrapper)
        
        contentView.addSubview(uppercaseMark)
        contentView.addSubview(uppercaseLabel)
        contentView.addSubview(lowercaseMark)
        contentView.addSubview(lowercaseLabel)
        contentView.addSubview(characterCountMark)
        contentView.addSubview(characterCountLabel)
        contentView.addSubview(numberMark)
        contentView.addSubview(numberLabel)
        
        contentView.addSubview(changePasswordButton)
        
        titleLabel.text = "Change Password"
        
        oldPasswordWrapper.titleLabel.text = "Old Password".uppercased()
        newPasswordWrapper.titleLabel.text = "New Password".uppercased()
        confirmPasswordWrapper.titleLabel.text = "Confirm New Password".uppercased()
        
        oldPasswordWrapper.textField.returnKeyType = .next
        newPasswordWrapper.textField.returnKeyType = .next
        confirmPasswordWrapper.textField.returnKeyType = .default
        
        uppercaseLabel.text = "1 uppercase letter"
        lowercaseLabel.text = "1 lowercase letter"
        characterCountLabel.text = "8 or more characters"
        numberLabel.text = "1 number"
        
        uppercaseMark.image = invalidImage
        lowercaseMark.image = invalidImage
        characterCountMark.image = invalidImage
        numberMark.image = invalidImage
        
        uppercaseMark.contentMode = .center
        lowercaseMark.contentMode = .center
        numberMark.contentMode = .center
        characterCountMark.contentMode = .center
        
        changePasswordButton.setTitle("Change Password".uppercased(), for: .normal)
        
        changePasswordButton.isEnabled = false
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DefaultSizes.topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            oldPasswordWrapper.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DefaultSizes.topPadding),
            oldPasswordWrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            oldPasswordWrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            newPasswordWrapper.topAnchor.constraint(equalTo: oldPasswordWrapper.bottomAnchor, constant: DefaultSizes.topPadding),
            newPasswordWrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            newPasswordWrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            
            uppercaseMark.topAnchor.constraint(equalTo: newPasswordWrapper.bottomAnchor, constant: 8),
            uppercaseMark.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            uppercaseLabel.centerYAnchor.constraint(equalTo: uppercaseMark.centerYAnchor),
            uppercaseLabel.leadingAnchor.constraint(equalTo: uppercaseMark.trailingAnchor, constant: 8),
            
            lowercaseMark.topAnchor.constraint(equalTo: uppercaseMark.bottomAnchor, constant: 8),
            lowercaseMark.leadingAnchor.constraint(equalTo: uppercaseMark.leadingAnchor),
            lowercaseLabel.centerYAnchor.constraint(equalTo: lowercaseMark.centerYAnchor),
            lowercaseLabel.leadingAnchor.constraint(equalTo: lowercaseMark.trailingAnchor, constant: 8),
            
            characterCountMark.centerYAnchor.constraint(equalTo: uppercaseMark.centerYAnchor),
            characterCountMark.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            characterCountLabel.centerYAnchor.constraint(equalTo: uppercaseMark.centerYAnchor),
            characterCountLabel.leadingAnchor.constraint(equalTo: numberMark.trailingAnchor, constant: 8),
            
            numberMark.centerYAnchor.constraint(equalTo: lowercaseMark.centerYAnchor),
            numberMark.leadingAnchor.constraint(equalTo: characterCountMark.leadingAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: numberMark.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: numberMark.trailingAnchor, constant: 8),
            
            
            confirmPasswordWrapper.topAnchor.constraint(equalTo: lowercaseLabel.bottomAnchor, constant: 28),
            confirmPasswordWrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            confirmPasswordWrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            changePasswordButton.topAnchor.constraint(equalTo: confirmPasswordWrapper.bottomAnchor, constant: DefaultSizes.topPadding),
            changePasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            changePasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 48),
            
        ])
    }
    
    override func refreshStyling() {
        backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        titleLabel.setStyle(.titleLabel)
        
        oldPasswordWrapper.setStyle(textFieldStyle: .passwordTextField)
        oldPasswordWrapper.setPlaceholder(text: "Type your password", color: ColorThemeManager.shared.theme.secondaryTextColor)
        newPasswordWrapper.setStyle(textFieldStyle: .passwordTextField)
        newPasswordWrapper.setPlaceholder(text: "Type your new password", color: ColorThemeManager.shared.theme.secondaryTextColor)
        confirmPasswordWrapper.setStyle(textFieldStyle: .passwordTextField)
        confirmPasswordWrapper.setPlaceholder(text: "Type your new password", color: ColorThemeManager.shared.theme.secondaryTextColor)
        
        uppercaseLabel.setStyle(.settingsItemLabel)
        lowercaseLabel.setStyle(.settingsItemLabel)
        numberLabel.setStyle(.settingsItemLabel)
        characterCountLabel.setStyle(.settingsItemLabel)
        
        changePasswordButton.setStyle(.primaryButton)
    }
    
    func updatePasswordRequirements() {
        uppercaseMark.image = newPasswordWrapper.textField.text?.containsUppercaseCharacter() ?? false ? validImage : invalidImage
        lowercaseMark.image = newPasswordWrapper.textField.text?.containsLowercaseCharacter() ?? false ? validImage : invalidImage
        numberMark.image = newPasswordWrapper.textField.text?.containsDigit() ?? false ? validImage : invalidImage
        characterCountMark.image = (newPasswordWrapper.textField.text?.count ?? 0) >= 8 ? validImage : invalidImage
    }
    
    func showPasswordsMustMatch() {
        confirmPasswordWrapper.showMessage(message: "Passwords must match", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func showNewPasswordMustBeDifferent() {
        newPasswordWrapper.showMessage(message: "New password cannot be the same as your old password", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func hideErrorMessage(_ wrapper: TextFieldWrapperView) {
        wrapper.hideMessage()
    }
}
