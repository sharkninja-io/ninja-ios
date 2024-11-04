//
//  ChangeEmailView.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/29/22.
//

import UIKit

class ChangeEmailView: BaseView {
    
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout var currentEmailLabel = UILabel()
    @UsesAutoLayout var emailWrapper = TextFieldWrapperView()
    @UsesAutoLayout var confirmWrapper = TextFieldWrapperView()
    @UsesAutoLayout var changeEmailButton = UIButton()
    
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(currentEmailLabel)
        addSubview(emailWrapper)
        addSubview(confirmWrapper)
        addSubview(changeEmailButton)
        
        titleLabel.text = "Change Email"
        
        emailWrapper.titleLabel.text = "Email".uppercased()
        emailWrapper.textField.placeholder = "Type new email"

        confirmWrapper.titleLabel.text = "Confirm new email".uppercased()
        confirmWrapper.placeholder = "Type new email"
        
        changeEmailButton.setTitle("Update + Log Out".uppercased(), for: .normal)
        changeEmailButton.isEnabled = false
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DefaultSizes.topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            currentEmailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            currentEmailLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            currentEmailLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            emailWrapper.topAnchor.constraint(equalTo: currentEmailLabel.bottomAnchor, constant: 32),
            emailWrapper.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            emailWrapper.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            confirmWrapper.topAnchor.constraint(equalTo: emailWrapper.bottomAnchor, constant: 24),
            confirmWrapper.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            confirmWrapper.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            changeEmailButton.topAnchor.constraint(equalTo: confirmWrapper.bottomAnchor, constant: 32),
            changeEmailButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            changeEmailButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            changeEmailButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.titleLabel)
        currentEmailLabel.setStyle(.infoLabel)
        
        emailWrapper.setStyle(textFieldStyle: .changeEmailTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        confirmWrapper.setStyle(textFieldStyle: .changeEmailTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        
        changeEmailButton.setStyle(.primaryButton)
    }
    
    func showEmailError() {
        emailWrapper.showMessage(message: "Please enter a valid email address.", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func showEmailSuggestion(domain: String) {
        emailWrapper.showMessage(message: "Did you mean \(domain)?", color: ColorThemeManager.shared.theme.primaryAccentColor)
    }
    
    func showEmailNotMatchingMessage() {
        confirmWrapper.showMessage(message: "Email must match.", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func hideErrorMessage(_ wrapper: TextFieldWrapperView) {
        wrapper.hideMessage()
    }
}
