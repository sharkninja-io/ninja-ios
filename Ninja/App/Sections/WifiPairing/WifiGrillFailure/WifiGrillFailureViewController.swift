//
//  WifiGrillFailureViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class WifiGrillFailureViewController: BaseViewController<WifiGrillFailureView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
        
        subview.continueButton.onEvent(closure: toNext(_:))
        
        navigationItem.hidesBackButton = true
    }
    
    func toNext(_ control: UIControl) {
        navigationController?.popToViewController(toControllerType: PairingPreparationViewController.self, animated: true)
    }

}

extension WifiGrillFailureViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PairingFailureItem.connectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PairingFailureItem.connectionItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PairGrillFailureCell.VIEW_ID, for: indexPath)
        (cell as? PairGrillFailureCell)?.titleLabel.text = item.title
        (cell as? PairGrillFailureCell)?.infoLabel.text = item.info
        (cell as? PairGrillFailureCell)?.iconView.image = item.image
        return cell
    }
}
