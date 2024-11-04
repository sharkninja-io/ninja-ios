//
//  BTConnectingLoadingViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/28/22.
//

import UIKit

class BTConnectingLoadingViewController: BTPairingBaseViewController<BTConnectingLoadingView> {
    
    var timer: Timer? = nil
    var isRedirecting = false
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        Logger.Debug("BT_PAIRING: CONNECTING TO DEVICE...")
        if let uuid = viewModel.selectedBluetoothUUIDSubject.value {
            viewModel.peripheralConnectionSubject.receive(on: DispatchQueue.main).sink { [weak self] wrapper in
                guard let self = self else { return }
                
                self.viewModel.stopScanForDevices()
                
                Logger.Debug("BT_PAIRING: DEVICE CONNECTION: \(wrapper)")
                if wrapper.1.identifier.uuidString == uuid {
                    switch wrapper.0 {
                    case .failedToConnect:
                        self.showConnectionError()
                    case .connected:
                        self.timer?.invalidate()
                        if !self.isRedirecting {
                            self.subview.complete {
                                self.toNameDevice()
                            }
                            self.isRedirecting = true
                        }
                    default:
                        break
                    }
                }
                
            }.store(in: &disposables)
        
            viewModel.killAdvertisementMonitor()
            viewModel.connectToPeripheral(uuidString: uuid)
            
            timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { [weak self] timer in
                timer.invalidate()
                
                Logger.Debug("BT_PAIRING: CONNECTING TO DEVICE: TIMEOUT")
                self?.showConnectionError()
            })
        } else {
            showConnectionError()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subview.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        subview.activityWorking.stop()
    }
    
    @objc func showConnectionError() {
        let vc = AlertModalViewController(
            title: "Oops, looks like there has been an incident while connecting.",
            description: "Please try to connect to your Grill again.",
            topIcon: IconAssetLibrary.ico_error_filled_circle.asImage(),
            image: ImageAssetLibrary.img_grill_error_state.asImage(),
            primaryAction: .init(title: "Try Again".uppercased(), alertAction: { [ weak self] in self?.backToPairingPreparation() }),
            dismissCallback: { [ weak self] in self?.backToPairingPreparation() },
            preventDismissalWithoutAction: true
        )
        self.present(vc, animated: false)
    }
    
    func toNameDevice() {
        navigationController?.pushViewController(BTNameDeviceViewController(), animated: true)
    }
    
    func backToPairingPreparation() {
        navigationController?.popToViewController(toControllerType: BTPairingPreparationViewController.self, animated: true)
    }
}
