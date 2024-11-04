//
//  BTPairingBaseViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 6/7/23.
//

import UIKit

class BTPairingBaseViewController<T: UIView>: BaseViewController<T> {
    
    private var authenticationViewModel: AuthenticationViewModel = .shared()
    var viewModel: BTPairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        hideBackButton = true
        hideExitButton = false
    }
    
    override func exitButtonBehavior() {
        if viewModel.userHasNoGrills() {
            showLogoutAlert()
        } else {
            showCancelPairingAlert()
        }
    }

    func showLogoutAlert() {
        let vc = AlertModalViewController(
            title: "Log Out?",
            description: "Pairing is required to access the app. Canceling the process will log you out.",
            primaryAction: .init(title: "Yes, log out", buttonStyle: .primaryButton, alertAction: { [weak self] in
                Logger.Debug("BT_PAIRING: EXITING / LOGOUT")
                self?.viewModel.completePairing()
                self?.authenticationViewModel.logout()
            }),
            secondaryAction: .init(title: "No, continue pairing", buttonStyle: .secondaryButton, alertAction: { return })
        )
        present(vc, animated: false)
    }
    
    func showCancelPairingAlert() {
        let vc = AlertModalViewController(
            title: "Cancel Pairing?",
            description: "You will have to start the process over again if you’d like to pair a new appliance.",
            primaryAction: .init(title: "Yes, cancel pairing", buttonStyle: .primaryButton, alertAction: { [weak self] in
                Logger.Debug("BT_PAIRING: EXITING")
                self?.viewModel.completePairing()
                self?.dismiss(animated: true)
            }),
            secondaryAction: .init(title: "No, continue pairing", buttonStyle: .secondaryButton, alertAction: { return })
        )
        present(vc, animated: false)
    }
    
}
