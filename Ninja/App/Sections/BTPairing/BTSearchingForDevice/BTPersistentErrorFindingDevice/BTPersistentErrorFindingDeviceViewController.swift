//
//  BTPersistentErrorViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/27/22.
//

import UIKit

class BTPersistentErrorFindingDeviceViewController: BTPairingBaseViewController<BTPersistentErrorFindingDeviceView> {
    
    override func setupViews() {
        super.setupViews()
        
        navigationController?.navigationBar.isHidden = true
        
        viewModel.stopScanForDevices()

        subview.connectWithWifiButton.onEvent() { [weak self] _ in
            self?.viewModel.btSearchAttempts = 0
            self?.navigationController?.pushViewController(PairingSplashViewController(), animated: true)
        }
        Logger.Debug("BT_PAIRING: PERSISTENT SEARCHING ERROR")
    }
}
