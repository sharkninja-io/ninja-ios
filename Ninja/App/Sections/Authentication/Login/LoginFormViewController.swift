//
//  LoginFormViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit

class LoginFormViewController: BaseViewController<LoginFormView> {
    
    private var viewModel: AuthenticationViewModel = .shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }

    override func setupViews() {
        super.setupViews()
        
        keyboardSizeObserverDelegate = DefaultKeyboardSizeObserverDelegate(
            view: subview,
            for: [subview.passwordWrapper.textField],
            maxY: subview.passwordWrapper.frame.maxY,
            keyboardPadding: 32)

        subview.emailWrapper.textField.delegate = self
        subview.passwordWrapper.textField.delegate = self
        subview.emailWrapper.isValid = { text in return text?.isEmail ?? false }
        if !viewModel.email.isEmpty {
            subview.emailWrapper.textField.text = viewModel.email
        }
        subview.passwordWrapper.isValid = { text in return text?.count ?? 0 > 0 }
        
        subview.emailWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.updateStatus() }
        subview.passwordWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.updateStatus() }
        subview.loginButton.onEvent{ [weak self] _ in self?.attemptLogin() }
        subview.forgotPasswordButton.onEvent{ [weak self] _ in self?.toForgotPasswordPage() }
        subview.signUpButton.onEvent{ [weak self] _ in self?.toCreateAccount() }

        if viewModel.isPasswordReset {
            subview.showPasswordReset()
            viewModel.isPasswordReset = false
        } else if viewModel.accountExists {
            subview.showExistingAccountError()
            viewModel.accountExists = false
        } else if !viewModel.isCountryCached() {
            subview.showExistingAccountInfo()
        }
    }
    
    override func subscribeToSubjects() {
        viewModel.authenticationUpdateSubject.receive(on: DispatchQueue.main).sink { [weak self] status in
            guard let self = self else { return }
            switch status {
                case .LoggedIn:
                    NavigationManager.shared.toMainMenu(window: self.view.window)
                case .LogInFailed:
                    self.subview.showLoginError()
                default:
                    break
            }
        }.store(in: &disposables)
    }
    
    private func updateStatus() {
        if subview.emailWrapper.isTextValid() {
            viewModel.email = subview.emailWrapper.textField.text ?? ""
            subview.loginButton.isEnabled = subview.passwordWrapper.isTextValid()
        } else {
            subview.loginButton.isEnabled = false
        }
    }
    
    private func attemptLogin() {
        if let email = subview.emailWrapper.textField.text,
           let password = subview.passwordWrapper.textField.text {
            viewModel.login(email: email, password: password)
        }
    }
    
    private func toCreateAccount() {
        navigationController?.pushViewController(CreateAccountFormViewController(), animated: true)
    }
    
    private func toForgotPasswordPage() {
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
}

extension LoginFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case subview.emailWrapper.textField:
            textField.resignFirstResponder()
            subview.passwordWrapper.textField.becomeFirstResponder()
            return true
        case subview.passwordWrapper.textField:
            if subview.loginButton.isEnabled {
                attemptLogin()
            } else {
                textField.resignFirstResponder()
            }
            return true
        default:
            return false
        }
    }
}
