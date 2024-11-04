//
//  ForgotPasswordViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit

class ForgotPasswordViewController: BaseViewController<ForgotPasswordView> {
    
    private var viewModel: AuthenticationViewModel = .shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }

    override func subscribeToSubjects() {
        viewModel.authenticationUpdateSubject.receive(on: DispatchQueue.main).sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .RequestedPasswordReset:
                self.navigationController?.pushViewController(ForgotAlmostThereViewController(), animated: true)
            case .RequestedPasswordResetFailed:
                self.subview.showRequestError()
            default:
                break
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        super.setupViews()
        
        subview.emailWrapper.isValid = { text in text?.isEmail ?? false }
        if !viewModel.email.isEmpty {
            subview.emailWrapper.textField.text = viewModel.email
            updateStatus()
        }
        subview.emailWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.updateStatus() }
        subview.continueButton.onEvent{ [weak self] _ in self?.requestPasswordReset() }
        subview.signUpButton.onEvent{ [weak self] _ in self?.toCreateAccount() }
    }
    
    private func updateStatus() {
        if subview.emailWrapper.isTextValid() {
            viewModel.email = subview.emailWrapper.textField.text ?? ""
        }
        subview.continueButton.isEnabled = subview.emailWrapper.isTextValid()
    }
    
    private func requestPasswordReset() {
        if let email = subview.emailWrapper.textField.text {
            viewModel.requestPasswordReset(email: email)
        } else {
            subview.showEmailError()
        }
        navigationController?.pushViewController(ForgotAlmostThereViewController(), animated: true)
    }
    
    private func toCreateAccount() {
        navigationController?.pushViewController(CreateAccountFormViewController(), animated: true)
    }
    
    private func toSignIn(_ sender: UIControl) {
        navigationController?.pushViewController(LoginFormViewController(), animated: true)
    }
}
