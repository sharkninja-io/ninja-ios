//
//  CreateAccountFormViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit

class CreateAccountFormViewController: BaseViewController<CreateAccountFormView> {
    
    private var viewModel: AuthenticationViewModel = .shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    override func subscribeToSubjects() {
        viewModel.authenticationUpdateSubject.receive(on: DispatchQueue.main).sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .AccountCreated:
                self.navigationController?.pushViewController(EmailVerificationViewController(), animated: true)
            case .AccountCreationFailed(let error):
                if self.viewModel.isEmailTakenError(error) {
                    self.viewModel.accountExists = true
                    self.toSignIn()
                } else {
                    self.subview.showCreationFailedError()
                }
            default:
                break
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        super.setupViews()
        
        subview.emailWrapper.isValid = { text in return text?.isEmail ?? false }
        subview.emailWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.emailChanged() }
        if !viewModel.email.isEmpty {
            subview.emailWrapper.textField.text = viewModel.email
            emailChanged()
        }
        subview.emailWrapper.textField.delegate = self

        subview.passwordWrapper.isValid = { [weak self] text in text?.range(of: self?.viewModel.passwordPattern ?? "", options: .regularExpression) != nil }
        subview.passwordWrapper.textField.delegate = self
        subview.passwordWrapper.textField.onEvent(for: .allEditingEvents) { [weak self] _ in self?.passwordChanged() }

        subview.termsCheckbox.onEvent{ [weak self] _ in self?.enableCreate() }
        subview.privacyCheckbox.onEvent{ [weak self] _ in self?.enableCreate() }
        subview.termsButton.onEvent{ [weak self] _ in self?.toTerms() }
        subview.privacyButton.onEvent{ [weak self] _ in self?.toPrivacy() }
        subview.continueButton.onEvent{ [weak self] _ in self?.createAccount() }
        subview.signInButton.onEvent{ [weak self] _ in self?.toSignIn() }
        
        // Display on first load only
        if !viewModel.isCountryCached() {
            subview.showExistingAccountInfo()
        }
    }
    
    private func emailChanged() {
        if subview.emailWrapper.isTextValid() {
            viewModel.email = subview.emailWrapper.textField.text ?? ""
            if let text = subview.emailWrapper.textField.text,
               let domain = viewModel.recommendDomain(email: text) {
                subview.showEmailSuggestion(domain: domain)
            } else {
                subview.hideEmailMessage()
            }
        } else {
            subview.showEmailError()
        }
        enableCreate()
    }
    
    private func passwordChanged() {
        subview.updatePasswordRequirements()
        enableCreate()
    }
    
    private func enableCreate() {
        self.subview.continueButton.isEnabled = self.subview.emailWrapper.isTextValid() && self.subview.passwordWrapper.isTextValid() && self.subview.termsCheckbox.isChecked && self.subview.privacyCheckbox.isChecked
    }
    
    private func toTerms() {
        self.present(TermsOfUseViewController(), animated: true)
    }
    
    private func toPrivacy() {
        self.present(PrivacyPolicyViewController(), animated: true)
    }
    
    private func createAccount() {
        if let password = subview.passwordWrapper.textField.text {
            viewModel.createAccount(email: viewModel.email, password: password)
        } else {
            subview.showCreationFailedError()
        }
    }
    
    private func toSignIn() {
        navigationController?.pushViewController(LoginFormViewController(), animated: true)
    }
    
}

extension CreateAccountFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case subview.emailWrapper.textField:
            textField.resignFirstResponder()
            subview.passwordWrapper.textField.becomeFirstResponder()
            return true
        case subview.passwordWrapper.textField:
            textField.resignFirstResponder()
            return true
        default:
            return false
        }
    }
}
