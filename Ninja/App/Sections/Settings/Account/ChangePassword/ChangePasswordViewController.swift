//
//  ChangePasswordViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/13/22.
//

import UIKit

class ChangePasswordViewController: BaseViewController<ChangePasswordView> {
    
    private let viewModel: SettingsViewModel = .shared()
    
    var oldPassword: String? { get {return subview.oldPasswordWrapper.textField.text} }
    var newPassword: String? { get {return subview.newPasswordWrapper.textField.text} }
    var confirmedPassword: String? { get {return subview.confirmPasswordWrapper.textField.text} }
    var formIsValid: Bool { get {return (oldPassword != newPassword) && (newPassword == confirmedPassword) && subview.newPasswordWrapper.isTextValid()} }
        
    override func subscribeToSubjects() {
        viewModel.changePasswordSubject.receive(on: DispatchQueue.main).sink { [weak self] success in
            guard let self else { return }
            if success {
                self.viewModel.forceLogout()
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.showErrorModal()
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        subview.newPasswordWrapper.isValid = { text in text?.range(of: AuthenticationViewModel.shared().passwordPattern, options: .regularExpression) != nil }
        
        subview.oldPasswordWrapper.textField.delegate = self
        subview.newPasswordWrapper.textField.delegate = self
        subview.confirmPasswordWrapper.textField.delegate = self
        
        subview.newPasswordWrapper.textField.onEvent(for: .editingChanged, closure: newPasswordTextChanged(_:))
        subview.confirmPasswordWrapper.textField.onEvent(for: .editingChanged, closure: confirmedPasswordTextChanged(_:))
        
        subview.changePasswordButton.onEvent() { [weak self] _ in self?.changePassword() }
    }
    
    private func changePassword() {
        viewModel.changePassword(old: subview.oldPasswordWrapper.textField.text ?? "", new: subview.newPasswordWrapper.textField.text ?? "")
    }
    
    private func newPasswordTextChanged(_ sender: UIControl) {
        subview.updatePasswordRequirements()
        if oldPassword == newPassword {
            subview.showNewPasswordMustBeDifferent()
        } else {
            subview.hideErrorMessage(subview.newPasswordWrapper)
        }
        subview.changePasswordButton.isEnabled = formIsValid
    }
    
    private func confirmedPasswordTextChanged(_ sender: UIControl) {
        if newPassword != confirmedPassword {
            subview.showPasswordsMustMatch()
        } else {
            subview.hideErrorMessage(subview.confirmPasswordWrapper)
        }
        subview.changePasswordButton.isEnabled = formIsValid
    }
}

extension ChangePasswordViewController {
    func showErrorModal() {
        let vc = AlertModalViewController(
            title: "Oops, something went wrong!",
            description: "The save attempt has failed. Try again?",
            primaryAction: .init(title: "Retry", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                self?.changePassword()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { return })
        )
        present(vc, animated: false)
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == subview.oldPasswordWrapper.textField {
            subview.newPasswordWrapper.textField.becomeFirstResponder()
        } else if textField == subview.newPasswordWrapper.textField {
            subview.confirmPasswordWrapper.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
