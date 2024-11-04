//
//  ResetPasswordViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit

class ResetPasswordViewController: BaseViewController<ResetPasswordView> {
    
    private var viewModel: AuthenticationViewModel = .shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }

    override func subscribeToSubjects() {
        viewModel.authenticationUpdateSubject.receive(on: DispatchQueue.main).sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .PasswordReset:
                self.toSignIn()
            case .PasswordResetFailed:
                self.subview.showResetError()
            default:
                break
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        super.setupViews()
        
        subview.passwordWrapper.isValid = { [weak self] text in text?.range(of: self?.viewModel.passwordPattern ?? "", options: .regularExpression) != nil }

        subview.passwordWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.passwordChanged() }
        subview.resetButton.onEvent{ [weak self] _ in self?.resetPassword() }
    }
    
    private func passwordChanged() {
        subview.updatePasswordRequirements()
        subview.resetButton.isEnabled = subview.passwordWrapper.isTextValid()
    }

    private func resetPassword() {
        if let token = viewModel.resetToken, let password = subview.passwordWrapper.textField.text {
            viewModel.resetPassword(token: token, password: password)
        } else {
            subview.showInvalidFieldsError()
        }
    }

    @objc private func toCreateAccount() {
        navigationController?.pushViewController(CreateAccountFormViewController(), animated: true)
    }
    
    private func toSignIn() {
        NavigationManager.shared.toAuthentication(window: self.view.window)
    }
}
