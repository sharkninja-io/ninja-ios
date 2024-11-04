//
//  ErrorFindingGrillViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/27/22.
//

import UIKit

class BTErrorFindingDeviceViewController: BTPairingBaseViewController<BTErrorFindingDeviceView> {
    
    override func setupViews() {
        super.setupViews()
        
        viewModel.stopScanForDevices()
        
        subview.tryAgainButton.onEvent() { [weak self] _ in
            self?.viewModel.btSearchAttempts += 1
            self?.navigationController?.popToViewController(toControllerType: BTSearchingForDeviceViewController.self, animated: true)
        }
        Logger.Debug("BT_PAIRING: SEARCHING ERROR")
   }
}
