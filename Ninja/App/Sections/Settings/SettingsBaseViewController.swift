//
//  SettingsBaseViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/26/22.
//

import UIKit

class SettingsBaseViewController<T: UIView>: BaseViewController<T> {
    
    var viewModel: SettingsViewModel = .shared()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectTableViewCells()
    }
    
    override func subscribeToSubjects() {
        viewModel.profileSaveSubject.receive(on: DispatchQueue.main).sink { [weak self] saveSuccessful in
            guard let self else { return }
            if !saveSuccessful { self.showProfileSaveFailure() }
        }.store(in: &disposables)
        
    }
    
    internal func deselectTableViewCells() {
        if let subview = subview as? SettingsStandardTableView {
            if let indexPath = subview.tableView.indexPathForSelectedRow {
                subview.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // MARK: Modals
    
    // TODO: These modals might need to be presented from various different view controllers. Decide if we want to remove SettingsBaseViewController and duplicate this code in each individual controller or not.
    
    // TODO: Need an object that observes the internet connection state.
    func showNoInternetConnectionError() {
        let vc = AlertModalViewController(
            title: "An internet connection is required to complete this task.",
            description: "Please connect to the internet and try again.",
            primaryAction: .init(title: "Ok".uppercased(), alertAction: { return })
        )
        present(vc, animated: false)
    }
        
    func showProfileSaveFailure() {
        let vc = AlertModalViewController(
            title: "Oops, something went wrong!",
            description: "The save attempt has failed. Try again?",
            primaryAction: .init(title: "Retry", buttonStyle: .destructivePrimaryButton, alertAction: {
                // TODO: Let the user immediately resend the request without making any changes
                return
                
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { return })
        )
        present(vc, animated: false)
    }
}
