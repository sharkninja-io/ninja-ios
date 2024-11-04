//
//  BTSearchingForDeviceViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/23/22.
//

import UIKit

class BTSearchingForDeviceViewController: BTPairingBaseViewController<BTSearchingForDeviceView> {
    
    var timer: Timer? = nil
    var isRedirecting = false
    
    override func setupViews() {
        super.setupViews()
        
        viewModel.initializeBluetoothScan()
        Logger.Debug("BT_PAIRING: SEARCHING...")
    }
        
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.pairableGrillsSubject.receive(on: DispatchQueue.main).sink { [weak self] pairableGrills in
            guard let self = self else { return }
            Logger.Debug("BT_PAIRING: SEARCHING: \(pairableGrills.count)")
            if !pairableGrills.isEmpty, !self.isRedirecting {
                self.timer?.invalidate()
                self.isRedirecting = true
                self.toDeviceFound()
            }
        }.store(in: &disposables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subview.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.monitorAdvertisementData()
        viewModel.startScanForDevices()
        // TODO: - Functionality???
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { [weak self] timer in
            timer.invalidate()
            
            Logger.Debug("BT_PAIRING: SEARCHING: TIMEOUT")
            guard let self = self else { return }
//            if self.viewModel.btSearchAttempts == 0 {
                self.toDeviceNotFoundError()
//            } else {
//                self.toPersistentDeviceNotFoundError()
//            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    func toDeviceFound() {
        navigationController?.pushViewController(BTDeviceDetectedViewController(), animated: true)
    }
    
    func toDeviceNotFoundError() {
        navigationController?.pushViewController(BTErrorFindingDeviceViewController(), animated: true)
    }
    
//    func toPersistentDeviceNotFoundError() {
//        navigationController?.pushViewController(BTPersistentErrorFindingDeviceViewController(), animated: true)
//    }
}
