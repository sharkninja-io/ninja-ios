//
//  WifiPasswordViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class WifiPasswordViewController: BaseViewController<WifiPasswordView> {
    
    let viewModel: PairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        if let wifiTitle = viewModel.selectedWifiNetwork?.ssid {
            subview.titleLabel.text = wifiTitle
        }
        subview.passwordWrapper.isValid = { $0?.count ?? 0 > 0 }
        subview.passwordWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in
            self?.checkEnableContinue()
        }
        subview.noPasswordCheckbox.onEvent { [weak self] _ in
            self?.checkEnableContinue()
        }
        subview.continueButton.isEnabled = false
        subview.continueButton.onEvent(closure: toConnectGrillToWifi(_:))
        
        navigationItem.hidesBackButton = false
    }
    
    func checkEnableContinue() {
        subview.continueButton.isEnabled = subview.passwordWrapper.isTextValid() || subview.noPasswordCheckbox.isChecked
    }
    
    func toConnectGrillToWifi(_ control: UIControl) {
        viewModel.selectedWifiNetwork?.password = subview.passwordWrapper.textField.text
        navigationController?.pushViewController(WifiGrillConnectionViewController(), animated: true)
    }

}
