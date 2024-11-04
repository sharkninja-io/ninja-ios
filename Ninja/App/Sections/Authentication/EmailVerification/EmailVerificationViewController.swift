//
//  EmailVerificationViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit

class EmailVerificationViewController: BaseViewController<EmailVerificationView> {
    
    private var viewModel: AuthenticationViewModel = .shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subview.emailAddress = viewModel.email.isEmpty ? "your email" : viewModel.email
    }
    
    override func setupViews() {
        super.setupViews()
        
        subview.resendButton.onEvent{ [weak self] _ in self?.resendCodeEmail() }
        subview.startOverButton.onEvent{ [weak self] _ in self?.startOver() }
        
        // TODO: //
//        subview.showAccountNotVerifiedError()
    }

    private func resendCodeEmail() {
        if !viewModel.email.isEmpty {
            viewModel.sendConfirmation(email: viewModel.email)
        }
    }
    
    private func startOver() {
        navigationController?.pushViewController(CreateAccountFormViewController(), animated: true)
    }
    
    private func toSignIn(_ sender: UIControl) {
        navigationController?.pushViewController(LoginFormViewController(), animated: true)
    }
}
