//
//  WifiGrillSetupViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class WifiGrillConnectionViewController: BaseViewController<WifiGrillConnectionView> {
    
    let viewModel: PairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        hideBackButton = true
        subview.continueButton.onEvent(closure: toGrillName(_:))
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.pairingStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            if state == .Connected {
                self?.subview.complete {
                    self?.viewModel.disconnectDeviceWifiHotspot()
                    self?.viewModel.pairingFailureCount = 0
                }
                self?.subview.continueButton.isHidden = false
            }
            Logger.Debug(state)
        }.store(in: &disposables)
        viewModel.pairingErrorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            guard let self = self else { return }
            
            self.viewModel.disconnectDeviceWifiHotspot()
            self.viewModel.pairingFailureCount += 1
            if self.viewModel.pairingFailureCount == 1 {
                self.toWifiFailureView()
            } else {
                self.toPersistentWifiFailureView()
            }
        }.store(in: &disposables)
        
        if let network = viewModel.selectedWifiNetwork {
            viewModel.setDeviceWifiNetwork(network: network)
        } else {
            self.toWifiFailureView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subview.start()
    }
    
    func toGrillName(_ sender: UIControl) {
        navigationController?.pushViewController(GrillNameViewController(), animated: true)
    }

    func toWifiFailureView() {
        navigationController?.pushViewController(WifiGrillFailureViewController(), animated: true)
    }
    
    func toPersistentWifiFailureView() {
        navigationController?.pushViewController(WifiGrillPersistentFailureViewController(), animated: true)
    }
}
