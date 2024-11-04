//
//  LoadingViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/16/22.
//

import Foundation
import UIKit

class DeletingAccountLoadingViewController: BaseViewController<DeletingAccountLoadingView> {
    
    private let viewModel: SettingsViewModel = .shared()
            
    let startingMessage: String?
    let completionMessage: String?
    
    init(startingMessage: String? = nil, completionMessage: String? = nil) {
        self.startingMessage = startingMessage
        self.completionMessage = completionMessage
        super.init(nibName: nil, bundle: nil)
        hideBackButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.accountDeletedSubject.receive(on: DispatchQueue.main).sink { [weak self] success in
            guard let self else { return }
            if success {
                self.complete()
            } else {
                self.showDeleteAccountError()
            }
        }.store(in: &disposables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let startingMessage {
            subview.messagelabel.text = startingMessage
        } else {
            subview.messagelabel.isHidden = true
        }
        subview.activityView.start()
    }
    
    override func setupViews() {
        subview.continueButton.onEvent(closure: continueToAuthentication(_:))
        subview.messagelabel.text = startingMessage
    }
    
    func continueToAuthentication(_ sender: UIControl) {
        viewModel.forceLogout()
    }
    
    func complete() {
        if let completionMessage {
            subview.messagelabel.isHidden = false
            subview.messagelabel.text = completionMessage
        }
        
        subview.activityView.complete() { [weak self] in
            guard let self else { return }
            self.subview.continueButton.isHidden = false
        }
    }
}

// MARK: Modals
extension DeletingAccountLoadingViewController {
    func showDeleteAccountError() {
        let vc = AlertModalViewController(
            title: "Oops, something went wrong!",
            description: "There was an error deleting your account. Try again?",
            primaryAction: .init(title: "Retry", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                self?.viewModel.deleteAccount()
                self?.subview.messagelabel.text = self?.startingMessage
                self?.subview.activityView.start()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }),
            dismissCallback: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        )
        present(vc, animated: false)
    }
}
