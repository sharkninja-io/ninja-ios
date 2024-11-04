//
//  PairGrillViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PairGrillHotspotViewController: BaseViewController<PairGrillHotspotView> {
    
    let viewModel: PairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        viewModel.subscribeToHotspotService()
        hideBackButton = true
        
        subview.continueButton.onEvent(closure: toWifiSelection(_:))
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.selectedIPAddressSubject.receive(on: DispatchQueue.main).sink { [weak self] ipAddress in
            if ipAddress != nil {
                self?.subview.complete {
                    self?.viewModel.hotspotfailureCount = 0
                }
                self?.subview.continueButton.isHidden = false
            } else {
                // TODO: //
            }
        }.store(in: &disposables)
        viewModel.pairingErrorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            switch error {
            case .UserDeniedHotspot:
                self?.toUserDeniedHotspot()
            case .GrillHotspotConnectionFailed:
                if self?.viewModel.hotspotfailureCount == 0 {
                    self?.viewModel.hotspotfailureCount += 1
                    self?.toPairGrillHotspotFailure()
                } else {
                    self?.toPairGrillHotspotPersistentFailure()
                }
            default:
                Logger.Debug(error)
                break
            }
        }.store(in: &disposables)
        
        // cancel pairing for new device hotspot
        if viewModel.pairingStateSubject.value != .Idle {
            viewModel.cancelPairing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subview.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.startDeviceWifiHotspotScanning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.cancelDeviceWifiHotspotScanning()
    }
    
    func toWifiSelection(_ sender: UIControl) {
        navigationController?.pushViewController(WifiSelectionViewController(), animated: true)
    }

    func toUserDeniedHotspot() {
        navigationController?.pushViewController(PairGrillNetworkDeclinedViewController(), animated: true)
    }
    
    func toPairGrillHotspotFailure() {
        navigationController?.pushViewController(PairGrillFailureViewController(), animated: true)
    }
    
    func toPairGrillHotspotPersistentFailure() {
        navigationController?.pushViewController(PairGrillPersistentFailureViewController(), animated: true)
    }
}
