//
//  BTWifiPasswordViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/3/23.
//

import Foundation

import UIKit

class BTWifiPasswordViewController: BTPairingBaseViewController<BTWifiPasswordView> {
    
    override func setupViews() {
        super.setupViews()
                
        if let wifiTitle = viewModel.selectedWifiNetwork?.ssid {
            subview.titleLabel.text = wifiTitle
        }
        subview.passwordWrapper.isValid = { $0?.count ?? 0 > 0 }
        subview.passwordWrapper.textField.onEvent(for: .editingChanged) { [weak self] _ in self?.checkEnableContinue() }
        subview.noPasswordCheckbox.onEvent{ [weak self] _ in self?.checkEnableContinue() }
        subview.continueButton.onEvent{ [weak self] _ in self?.toConnectGrillToWifi() }
        subview.continueButton.isEnabled = false
        
        hideBackButton = false
        Logger.Debug("BT_PAIRING: WIFI PASSWORD")
    }
    
    func checkEnableContinue() {
        subview.continueButton.isEnabled = subview.passwordWrapper.isTextValid() || subview.noPasswordCheckbox.isChecked
    }
    
    func toConnectGrillToWifi() {
        viewModel.selectedWifiNetwork?.password = subview.passwordWrapper.textField.text
        navigationController?.pushViewController(BTConnectingToWifiViewController(), animated: true)
    }
}
