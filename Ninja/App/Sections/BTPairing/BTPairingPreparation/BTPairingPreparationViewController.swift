//
//  BTPairingPreparationViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class BTPairingPreparationViewController: BTPairingBaseViewController<BTPairingPreparationView> {
        
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.continueButton.onEvent{ [weak self] _ in self?.toNext() }
        Logger.Debug("BT_PAIRING: PREPARATION")
    }
    
    func toNext() {
        navigationController?.pushViewController(BTSearchingForDeviceViewController(), animated: true)
    }
}

extension BTPairingPreparationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BTPairingPreparationItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = BTPairingPreparationItem.items[indexPath.row]

        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BTPairingPreparationBottomImageCell.VIEW_ID, for: indexPath) as! BTPairingPreparationBottomImageCell
            cell.titleLabel.text = item.title
            cell.infoLabel.text = item.info
            cell.iconView.image = item.image
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BTPairingPreparationCell.VIEW_ID, for: indexPath) as! BTPairingPreparationCell
            cell.isImportant = item.important
            cell.titleLabel.text = item.title
            cell.infoLabel.text = item.info
            cell.moreButton.setTitle(item.buttonText, for: .normal)
            cell.iconView.image = item.image
            return cell
        }
    }
}

extension BTPairingPreparationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = BTPairingPreparationItem.items[indexPath.row].buttonViewController else { return }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true)
    }
}

extension BTPairingPreparationViewController: UIViewControllerTransitioningDelegate {
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartialPresentationController(presentedViewController: presented, presenting: presenting, height: 540)
    }

}
