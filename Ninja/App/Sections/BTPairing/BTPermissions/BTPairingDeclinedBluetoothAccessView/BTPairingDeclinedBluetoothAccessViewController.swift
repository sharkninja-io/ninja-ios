//
//  BTPairingDeclinedBluetoothAccessViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 12/27/22.
//

import Foundation
import UIKit

class BTPairingDeclinedBluetoothAccessViewController: BTPairingBaseViewController<BTPairingDeclinedBluetoothAccessView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.dataSource = self
        subview.continueButton.onEvent{ [weak self] _ in self?.toNext() }
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func executeIntentToSettings() {
        if let url = URL(string: "App-Prefs:root=Privacy&path=Local_Network"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: "App-prefs:root=General"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
        
//    func toBluetoothSettings(_ control: UIControl) {
//        if let url = URL(string: "prefs:root=Bluetooth"), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        } else if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(settingsURL)
//        }
//    }

    func toNext() {
        executeIntentToSettings()
    }
}

extension BTPairingDeclinedBluetoothAccessViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BTPairingDeclinedBluetoothAccessItem.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = BTPairingDeclinedBluetoothAccessItem.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BTPairingDeclinedBluetoothAccessViewCell.VIEW_ID, for: indexPath)
        (cell as? BTPairingDeclinedBluetoothAccessViewCell)?.nameLabel.text = "\(item.index). \(item.title)"
        return cell
    }
}


