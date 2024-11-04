//
//  BTPromptToConnectWifiViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/29/22.
//

import UIKit

class BTPromptToConnectWifiViewController: BTPairingBaseViewController<BTPromptToConnectWifiView> {
    
    override func setupViews() {
        super.setupViews()
        
        navigationController?.navigationBar.isHidden = true
        
        subview.startButton.onEvent() { [weak self] _ in self?.toWifiSelection() }
        Logger.Debug("BT_PAIRING: WIFI PROMPT")
    }
    
    func toWifiSelection() {
        navigationController?.pushViewController(BTWifiSelectionViewController(), animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
