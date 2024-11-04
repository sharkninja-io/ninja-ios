//
//  DeclinedPermissionViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class LocalNetworkPermissionDeclinedViewController: BaseViewController<LocalNetworkPermissionDeclinedView> {
    
    let permissionsObserver: AppLocalNetworkPermissionsObserver = .init()
    
    override func setupViews() {
        super.setupViews()
        
        subview.continueButton.onEvent(closure: toSettings(_:))
        navigationItem.hidesBackButton = true
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        permissionsObserver.permissionSubject.receive(on: DispatchQueue.main).sink { [weak self] hasPermission in
            Logger.Debug("PERMISSION: \(hasPermission)")
            if hasPermission {
                self?.toContinue()
            }
        }.store(in: &disposables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        permissionsObserver.checkPermission()
    }
    
    override func appWillEnterForeground() {
        super.appWillEnterForeground()
        
        permissionsObserver.checkPermission()
    }
    
    func toSettings(_ control: UIControl) {
        if let url = URL(string: "App-Prefs:root=Privacy&path=Local_Network"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func toContinue() {
        navigationController?.popToViewController(toControllerType: PairingPreparationViewController.self)
    }

}
