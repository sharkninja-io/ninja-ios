//
//  GrillNameViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class GrillNameViewController: BaseViewController<GrillNameView> {
    
    let viewModel: PairingViewModel = .shared
    
    var presentDelegate = ModalPresentationControllerDelegate(height: 600, dismiss: false)
    
    override func setupViews() {
        super.setupViews()
        
        subview.textFieldWrapper.placeholder = viewModel.grillName ?? ""
        subview.textFieldWrapper.textField.onEvent(for: .editingChanged)  { [weak self] control in
            self?.viewModel.grillName = self?.subview.textFieldWrapper.textField.text ?? ""
        }
        
        subview.continueButton.onEvent(closure: toNext(_:))
        navigationItem.hidesBackButton = true
    }
    
    func toNext(_ control: UIControl) {
        guard let dsn = viewModel.currentDeviceDSN else { return }
        
        Task {
            // TODO: Activity spinner???
            if let grillName = viewModel.grillName {
                _ = await viewModel.nameDevice(dsn: dsn, name: grillName)
            }
            let vc = PairingCompletedViewController()
            vc.dismissed = { [weak self] in
                self?.dismiss(animated: true)
            }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = presentDelegate
            self.present(vc, animated: true)
        }
    }

}
