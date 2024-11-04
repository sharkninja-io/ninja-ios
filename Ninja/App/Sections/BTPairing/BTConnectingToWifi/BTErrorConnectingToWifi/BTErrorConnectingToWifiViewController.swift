//
//  BTErrorConnectingToWifiViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/3/23.
//

import UIKit

class BTErrorConnectingToWifiViewController: BTPairingBaseViewController<BTErrorConnectingToWifiView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.dataSource = self
        
        subview.tryAgainButton.onEvent{ [weak self] _ in self?.tryAgainButtonTapped() }
        viewModel.wifiFailureCount += 1
        Logger.Debug("BT_PAIRING: ERROR CONNECTING TO WIFI!!!")
    }
    
    private func tryAgainButtonTapped() {
        navigationController?.popToViewController(toControllerType: BTWifiSelectionViewController.self, animated: true)
    }
}

extension BTErrorConnectingToWifiViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BTEducationalItem.firstErorrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTEducationalCell.VIEW_ID, for: indexPath) as! BTEducationalCell
        let item = BTEducationalItem.firstErorrItems[indexPath.row]
        cell.populate(with: item)
        return cell
    }
}
