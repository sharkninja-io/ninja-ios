//
//  PairingCompletedViewController.swift
//  Ninja
//
//  Created by Martin Burch on 12/7/22.
//

import UIKit

class PairingCompletedViewController: BaseViewController<PairingCompletedView> {
    
    let viewModel: PairingViewModel = .shared
    var dismissed: (() -> Void)? = nil
    
    override func setupViews() {
        super.setupViews()
        
        subview.grillName = viewModel.getGrillName() ?? "Grill"
        subview.continueButton.onEvent { [weak self] control in
            self?.dismiss(animated: true, completion: nil)
            self?.dismissed?()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subview.complete()
    }
}
