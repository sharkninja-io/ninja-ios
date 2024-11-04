//
//  ChangeEmailViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/29/22.
//

import UIKit

class ChangeEmailViewController: BaseViewController<ChangeEmailView> {
    
    private let viewModel: SettingsViewModel = .shared()
    
    override func setupViews() {
        subview.currentEmailLabel.text = viewModel.email
        
        subview.emailWrapper.textField.delegate = self
        subview.confirmWrapper.textField.delegate = self
        
        subview.emailWrapper.isValid = { text in return text?.isEmail ?? false }
        
        subview.emailWrapper.textField.onEvent(for: .editingChanged, closure: emailFieldChanged(_:))
        subview.confirmWrapper.textField.onEvent(for: .editingChanged, closure: emailFieldChanged(_:))
        
        subview.changeEmailButton.onEvent() { [weak self] _ in self?.changeEmail() }
    }
    
    override func subscribeToSubjects() {
        viewModel.changeEmailSubject.receive(on: DispatchQueue.main).sink { success in
            if success {
                self.viewModel.forceLogout()
            } else {
                self.showErrorModal()
            }
        }.store(in: &disposables)
    }
    
    private func emailFieldChanged(_ sender: UIControl) {
        if sender == subview.emailWrapper.textField {
            if subview.emailWrapper.isTextValid() { // Text is an email
                if let text = subview.emailWrapper.textField.text, let domain = AuthenticationViewModel.shared().recommendDomain(email: text) { // Matches email format, but resembles a common mistake
                    subview.showEmailSuggestion(domain: domain)
                } else { // Email appears valid
                    subview.hideErrorMessage(subview.emailWrapper)
                }
            } else { // Text is not an email
                subview.showEmailError()
            }
        } else if sender == subview.confirmWrapper.textField {
            if subview.emailWrapper.textField.text != subview.confirmWrapper.textField.text { // Emails don't match
                subview.showEmailNotMatchingMessage()
            } else { // Emails match
                subview.hideErrorMessage(subview.confirmWrapper)
            }
        }
        checkValidity()
    }
    
    private func checkValidity() {
        subview.changeEmailButton.isEnabled = subview.emailWrapper.isTextValid() && subview.emailWrapper.textField.text == subview.confirmWrapper.textField.text
    }
    
    private func changeEmail() {
        subview.changeEmailButton.isEnabled = false
        guard let email = subview.emailWrapper.textField.text else { return }
        viewModel.changeUserEmail(email)
    }
}

extension ChangeEmailViewController {
    func showErrorModal() {
        let vc = AlertModalViewController(
            title: "Oops, something went wrong!",
            description: "The save attempt has failed. Try again?",
            primaryAction: .init(title: "Retry", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                self?.changeEmail()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { return })
        )
        present(vc, animated: false)
    }
}

extension ChangeEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == subview.emailWrapper.textField {
            subview.confirmWrapper.textField.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return false
        }
    }
}
