//
//  PermissionPromptInfoViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PermissionPromptInfoViewController: BaseViewController<PermissionPromptInfoView> {
    
    let viewModel: PairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        subview.continueButton.onEvent(closure: toNext(_:))
        navigationController?.isNavigationBarHidden = false
        hideBackButton = true
    }
    
    func toNext(_ control: UIControl) {
        navigationController?.pushViewController(PairingPreparationViewController(), animated: true)
    }
}
