//
//  CreateVerifyingViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/16/22.
//

import UIKit

class CreateVerifyingViewController: BaseViewController<CreateVerifyingView> {
    
    private var viewModel: AuthenticationViewModel = .shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subview.activitySpinner.start()
    }
    
    override func subscribeToSubjects() {
        viewModel.authenticationUpdateSubject.receive(on: DispatchQueue.main).sink { [weak self] update in
            switch update {
            case .LoggedIn:
                self?.complete()
            case .LogInFailed:
                Logger.Error("Failed to log in after account confirmation")
                self?.subview.activitySpinner.stop()
                NavigationManager.shared.toAuthentication(window: self?.view.window)
            case .AccountConfirmed:
                self?.attemptLogin()
            case .AccountConfirmationFailed:
                Logger.Error("Failed Account Confirmation")
                self?.subview.activitySpinner.stop()
                NavigationManager.shared.toAuthentication(window: self?.view.window)
            default:
                break
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        super.setupViews()
        
        subview.continueButton.onEvent { [weak self] _ in
            NavigationManager.shared.toMainMenu(window: self?.view.window)
        }
    }

    private func attemptLogin() {
        let email = KeychainWrapper.fetch(.username)
        let password = KeychainWrapper.fetch(.password)
        viewModel.login(email: email, password: password)
    }
    
    private func complete() {
        subview.activitySpinner.complete(duration: 1, scaleToZero: true) {
            self.subview.isVerified = true
        }
        KeychainWrapper.deleteItem(.username)
        KeychainWrapper.deleteItem(.password)
    }
}
