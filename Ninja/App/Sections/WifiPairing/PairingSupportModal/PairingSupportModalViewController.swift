//
//  PairingModalViewController.swift
//  Ninja
//
//  Created by Martin Burch on 12/8/22.
//

import UIKit

class PairingSupportModalViewController: BaseViewController<PairingSupportModalView> {
    
    let viewModel: PairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        subview.primaryButton.onEvent { [weak self] _ in
            guard let self = self else { return }
            self.makeSupportCall()
        }
        subview.secondaryButton.onEvent { [weak self] _ in
            self?.toCancel()
        }
    }
    
    func toCancel() {
        self.dismiss(animated: true)
    }
    
    func makeSupportCall() {
        guard let url = URL(string: "tel://\(viewModel.supportNumber)") else { return }
        UIApplication.shared.open(url)
    }
}
