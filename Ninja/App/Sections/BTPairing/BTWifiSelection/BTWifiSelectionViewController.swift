//
//  BTWifiSelectionViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/3/23.
//

import UIKit

class BTWifiSelectionViewController: BTPairingBaseViewController<BTWifiSelectionView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self

        subview.wifiTipsButton.onEvent { [weak self] control in
            let viewController = BTWifiTipsViewController()
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
            self?.present(viewController, animated: true)
        }
        
        navigationController?.navigationBar.isHidden = false
        Logger.Debug("BT_PAIRING: WIFI SELECTION:")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subview.setSpinner(shouldShow: true)
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.deviceWifiNetworksSubject.receive(on: DispatchQueue.main).sink { [weak self] items in
            self?.subview.tableView.reloadData()
            if self?.subview.tableView.numberOfRows(inSection: 0) != 0 {
                self?.subview.setSpinner(shouldShow: false)
            }
            Logger.Debug("BT_PAIRING: WIFI SELECTION - \(items.count)")
        }.store(in: &disposables)
        
        viewModel.requestWifiNetworks()
    }
    
    func toWifiPassword() {
        navigationController?.pushViewController(BTWifiPasswordViewController(), animated: true)
    }
}

extension BTWifiSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.deviceWifiNetworksSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTWifiSelectionViewCell.VIEW_ID, for: indexPath)
        let network = viewModel.deviceWifiNetworksSubject.value[indexPath.row]
        if let btCell = cell as? BTWifiSelectionViewCell {
            btCell.nameLabel.text = network.ssid
            btCell.setSecured(isSecured: network.security != 0)
            btCell.setWifiStrength(strength: network.bars)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedWifiNetwork = viewModel.deviceWifiNetworksSubject.value[indexPath.row]
        viewModel.stopRequestWifiNetworks()
        toWifiPassword()
    }
}

extension BTWifiSelectionViewController: UIViewControllerTransitioningDelegate {
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartialPresentationController(presentedViewController: presented, presenting: presenting, height: 580)
    }

}
