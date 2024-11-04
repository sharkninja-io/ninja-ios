//
//  ForgotAlmostThere.swift
//  Ninja
//
//  Created by Martin Burch on 11/16/22.
//

import UIKit

class ForgotAlmostThereViewController: BaseViewController<ForgotAlmostThereView> {
    
    private var viewModel: AuthenticationViewModel = .shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }

    override func subscribeToSubjects() {
        viewModel.authenticationUpdateSubject.receive(on: DispatchQueue.main).sink { [weak self] event in
            guard let self = self else { return }
            // TODO: Universal link
            switch event {
            case .PasswordReset:
                self.toResetPassword()
                break
            case .PasswordResetFailed:
                break
            default:
                break
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        super.setupViews()
        
        subview.resendButton.onEvent{ [weak self] _ in self?.resendEmail() }
    }
    
    private func resendEmail() {
        // TODO: //
    }

    private func toResetPassword() {
        // TODO: //
    }

}
