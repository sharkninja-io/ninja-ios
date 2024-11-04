//
//  WifiGrillPersistentFailureViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class WifiGrillPersistentFailureViewController: BaseViewController<WifiGrillPersistentFailureView> {
    
    let modalDelegate = ModalPresentationControllerDelegate(height: 300)

    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.continueButton.onEvent(closure: toNext(_:))
        subview.supportButton.onEvent(closure: showCustomerSupportModal(_:))
        
        navigationItem.hidesBackButton = true
    }
    
    func toNext(_ control: UIControl) {
        navigationController?.popToViewController(toControllerType: PairingPreparationViewController.self, animated: true)
    }

    func showCustomerSupportModal(_ control: UIControl) {
        let vc = PairingSupportModalViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = modalDelegate
        self.present(vc, animated: true)
    }
}

extension WifiGrillPersistentFailureViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PairingFailureItem.persistentConnectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PairingFailureItem.persistentConnectionItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PairGrillPersistentFailureCell.VIEW_ID, for: indexPath)
        (cell as? PairGrillPersistentFailureCell)?.title = item.title
        (cell as? PairGrillPersistentFailureCell)?.info = item.info
        return cell
    }
}
