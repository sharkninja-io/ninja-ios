//
//  WifiSelectionViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class WifiSelectionViewController: BaseViewController<WifiSelectionView> {
    
    private var viewModel: PairingViewModel = .shared
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self

        subview.wifiTipsButton.onEvent { [weak self] control in
            let viewController = WifiTipsViewController()
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
            self?.present(viewController, animated: true)
        }
        
        navigationItem.hidesBackButton = false
        viewModel.subscribeToPairingService()
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.deviceWifiNetworksSubject.receive(on: DispatchQueue.main).sink { [weak self] items in
            self?.subview.tableView.reloadData()
        }.store(in: &disposables)
        
        viewModel.pairingStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            Logger.Debug(state)
            switch state {
            case .Idle:
                self?.viewModel.startPairing()
            default:
                break;
            }
        }.store(in: &disposables)
        
        viewModel.pairingErrorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            guard let self = self else { return }

            Logger.Error(error)
            self.viewModel.pairingFailureCount += 1
            if self.viewModel.pairingFailureCount == 1 {
                self.toWififFailure()
            } else {
                self.toWifiPersistentFailure()
            }
        }.store(in: &disposables)
    }
    
    func toWifiPassword() {
        navigationController?.pushViewController(WifiPasswordViewController(), animated: true)
    }

    func toWififFailure() {
        navigationController?.pushViewController(WifiGrillFailureViewController(), animated: true)
    }
    
    func toWifiPersistentFailure() {
        navigationController?.pushViewController(WifiGrillPersistentFailureViewController(), animated: true)
    }
}

extension WifiSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.deviceWifiNetworksSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WifiSelectionViewCell.VIEW_ID, for: indexPath)
        let network = viewModel.deviceWifiNetworksSubject.value[indexPath.row]
        (cell as? WifiSelectionViewCell)?.wifiNetwork = network
        (cell as? WifiSelectionViewCell)?.nameLabel.text = network.ssid
        (cell as? WifiSelectionViewCell)?.setSecured(isSecured: network.security != String.emptyOrNone)
        (cell as? WifiSelectionViewCell)?.setWifiStrength(strength: network.bars)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        viewModel.selectedWifiNetwork = (cell as? WifiSelectionViewCell)?.wifiNetwork
        toWifiPassword()
    }
}

extension WifiSelectionViewController: UIViewControllerTransitioningDelegate {
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartialPresentationController(presentedViewController: presented, presenting: presenting, height: 580)
    }

}
