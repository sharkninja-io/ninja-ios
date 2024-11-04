//
//  BTPersistentErrorConnectingToWifiViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/4/23.
//

import UIKit

class BTToWifiPersistentErrorConnectingViewController: BTPairingBaseViewController<BTToWifiPersistentErrorConnectingView> {
    
    let modalDelegate = ModalPresentationControllerDelegate(height: 300)
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
        
        subview.tryAgainButton.onEvent{ [weak self] _ in self?.tryAgainButtonTapped() }
        subview.contactSupportButton.onEvent{ [weak self] _ in self?.showCustomerSupportModal() }
        viewModel.wifiFailureCount += 1
        Logger.Debug("BT_PAIRING: PERSISTENT ERROR CONNECTING TO WIFI!!!")
    }
    
    private func tryAgainButtonTapped() {
        navigationController?.popToViewController(toControllerType: BTWifiSelectionViewController.self, animated: true)
    }
    
    private func showCustomerSupportModal() {
        let vc = PairingSupportModalViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = modalDelegate
        self.present(vc, animated: true)
    }
    
}

extension BTToWifiPersistentErrorConnectingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BTEducationalItem.persistentErrorItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTEducationalCell.VIEW_ID, for: indexPath) as! BTEducationalCell
        let item = BTEducationalItem.persistentErrorItems[indexPath.row]
        cell.populate(with: item)
        return cell
    }
    
}

extension BTToWifiPersistentErrorConnectingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
