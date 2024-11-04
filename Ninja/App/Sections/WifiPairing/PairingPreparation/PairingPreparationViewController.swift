//
//  PairingPreparationViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PairingPreparationViewController: BaseViewController<PairingPreparationView> {
    
    let permissionsObserver: AppLocalNetworkPermissionsObserver = .init()
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.continueButton.onEvent(closure: toNext(_:))
        navigationItem.hidesBackButton = false
   }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        permissionsObserver.permissionSubject.receive(on: DispatchQueue.main).sink { [weak self] hasPermission in
            if UIApplication.shared.applicationState == .active {
                if !hasPermission {
                    self?.toPermissionError()
                } else {
                    self?.subview.continueButton.isEnabled = true
                }
            }
        }.store(in: &disposables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subview.continueButton.isEnabled = false
        permissionsObserver.checkPermission()
    }
    
    override func appWillEnterForeground() {
        super.appWillEnterForeground()
        
        subview.continueButton.isEnabled = false
        permissionsObserver.checkPermission()
    }
    
    func toNext(_ control: UIControl) {
        navigationController?.pushViewController(PairGrillHotspotViewController(), animated: true)
    }

    func toPermissionError() {
        navigationController?.pushViewController(LocalNetworkPermissionDeclinedViewController(), animated: true)
    }
}

extension PairingPreparationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PairingPreparationItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PairingPreparationItem.items[indexPath.row]
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PairingPreparationBottomImageCell.VIEW_ID, for: indexPath)
            (cell as? PairingPreparationBottomImageCell)?.titleLabel.text = item.title
            (cell as? PairingPreparationBottomImageCell)?.infoLabel.text = item.info
            (cell as? PairingPreparationBottomImageCell)?.iconView.image = item.image
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PairingPreparationCell.VIEW_ID, for: indexPath)
            (cell as? PairingPreparationCell)?.isImportant = item.important
            (cell as? PairingPreparationCell)?.titleLabel.text = item.title
            (cell as? PairingPreparationCell)?.infoLabel.text = item.info
            (cell as? PairingPreparationCell)?.moreButton.setTitle(item.buttonText, for: .normal)
            (cell as? PairingPreparationCell)?.iconView.image = item.image
            return cell
        }
    }
}

extension PairingPreparationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = PairingPreparationItem.items[indexPath.row]

        if let vc = item.buttonViewController {
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.present(vc, animated: true)
        }
    }
}

extension PairingPreparationViewController: UIViewControllerTransitioningDelegate {
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartialPresentationController(presentedViewController: presented, presenting: presenting, height: 540)
    }

}
