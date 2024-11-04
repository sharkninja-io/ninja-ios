//
//  BTPermissionsViewController.swift
//  Ninja
//
//  Created by Martin Burch on 12/21/22.
//

import UIKit

class BTPermissionsViewController: BTPairingBaseViewController<BTPermissionsView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        subview.continueButton.onEvent{ [weak self] _ in self?.toNext() }
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        Logger.Debug("BT_PAIRING: PERMISSIONS...")
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.btStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            if state == .unauthorized {
                NavigationManager.shared.setBLEDenied(denied: true)
                Logger.Error("BT_PAIRING: Denied Bluetooth Permission")
                self?.toDeniedPermissions()
            } else if state == .poweredOn {
                Logger.Debug("BT_PAIRING: Approved Bluetooth Permission")
                self?.subview.setBluetoothEnabled()
                self?.subview.continueButton.isEnabled = true
            }
        }.store(in: &disposables)
    }
    
    func toNext() {
        navigationController?.pushViewController(BTPairingPreparationViewController(), animated: true)
    }
    
    func toDeniedPermissions() {
        navigationController?.pushViewController(BTPairingDeclinedBluetoothAccessViewController(), animated: true)
    }
}

extension BTPermissionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BTPermissionsItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = BTPermissionsItem.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BTPermissionsTableViewCell.VIEW_ID, for: indexPath)
        (cell as? BTPermissionsTableViewCell)?.nameLabel.text = item.title
        (cell as? BTPermissionsTableViewCell)?.descriptionLabel.text = item.description
        (cell as? BTPermissionsTableViewCell)?.isImportant = item.isImportant ?? false
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}

extension BTPermissionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.connectToBluetooth()
        }
    }
}
