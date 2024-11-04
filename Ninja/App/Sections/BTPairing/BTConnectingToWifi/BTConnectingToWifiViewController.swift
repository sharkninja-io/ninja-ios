//
//  BTConnectingToWifiViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/3/23.
//

import UIKit

class BTConnectingToWifiViewController: BTPairingBaseViewController<BTConnectingToWifiView> {
    
    var aylaStartTime: Date? = nil
    var dsn: String? = nil
    var timer: Timer? = nil

    override func setupViews() {
        super.setupViews()
        
        subview.toDashboardButton.onEvent{ [weak self] _ in self?.toDashboard() }
        Logger.Debug("BT_PAIRING: CONNECTING TO WIFI...")
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()

        dsn = nil
        if let network = viewModel.selectedWifiNetwork {
            viewModel.deviceWifiStatusSubject.receive(on: DispatchQueue.main).sink { [weak self] response in
                guard let self = self else { return }
                // BT timeout kill
                self.timer?.invalidate()
                switch response.status {
                case .Connected:
                    Logger.Debug("BT_PAIRING: WIFI CONNECTED")
                    Task {
                        let result = await self.viewModel.registerDevice()
                        if !result {
                            self.toFirstError()
                        }
                        self.aylaStartTime = Date()
                    }
                case .Error:
                    Logger.Error("BT_PAIRING: BT Wifi: \(response)")
                    if self.viewModel.wifiFailureCount == 0 {
                        self.toFirstError()
                    } else {
                        self.toPersistentError()
                    }
                default:
                    // TODO: //
                    break
                }
            }.store(in: &disposables)
            
            viewModel.apiPairingSubject.receive(on: DispatchQueue.main).sink { [weak self] dsn in
                guard let self = self else { return }
                
                self.dsn = dsn
                if let dsn = dsn {
                    Logger.Debug("BT_PAIRING: API RESULT: \(String(describing: dsn))")
                    Task {
                        await self.viewModel.nameDevice(name: self.viewModel.currentDeviceName, dsn: dsn)
                        self.viewModel.completePairing()
                        self.subview.complete()
                    }
                } else {
                    Logger.Debug("BT_PAIRING: API ERROR: FAILED!!!")
                    self.toFirstError()
                }
                
                if let startTime = self.aylaStartTime?.timeIntervalSince1970 {
                    let completeTime = Date().timeIntervalSince1970 - startTime
                    Logger.Debug("BT_PAIRING: API SECONDS: \(completeTime)")
                }
                Task {
                    let logs = await DevicePairingService.shared.readFromLog()
                    Logger.Debug("BT_PAIRING: LOGS: \(logs)")
                }
            }.store(in: &disposables)
            
            // BT timeout
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { [weak self] timer in
                timer.invalidate()
                
                Logger.Debug("BT_PAIRING: CONNECTING TO WIFI - TIMEOUT")
                guard let self = self else { return }
                self.toFirstError()
            })
            
            viewModel.connectToWifiNetwork(wifiNetwork: network)
        } else {
            // TODO: //
            toFirstError()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        subview.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        subview.stop()
    }
    
    func toDashboard() {
        dismiss(animated: true)
        if let dsn = dsn {
            viewModel.notifyDevicePaired(dsn: dsn)
        }
    }
    
    func toFirstError() {
        navigationController?.pushViewController(BTErrorConnectingToWifiViewController(), animated: true)
    }
    
    func toPersistentError() {
        navigationController?.pushViewController(BTToWifiPersistentErrorConnectingViewController(), animated: true)
    }
}
