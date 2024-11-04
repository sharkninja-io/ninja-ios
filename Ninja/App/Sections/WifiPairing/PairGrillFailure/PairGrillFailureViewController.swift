//
//  PairGrillFailureViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PairGrillFailureViewController: BaseViewController<PairGrillFailureView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.continueButton.onEvent(closure: toNext(_:))
        
        navigationItem.hidesBackButton = true
    }
    
    func toNext(_ control: UIControl) {
        navigationController?.popToViewController(toControllerType: PairingPreparationViewController.self, animated: true)
    }

}

extension PairGrillFailureViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PairingFailureItem.applianceItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PairingFailureItem.applianceItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PairGrillFailureCell.VIEW_ID, for: indexPath)
        (cell as? PairGrillFailureCell)?.titleLabel.text = item.title
        (cell as? PairGrillFailureCell)?.infoLabel.text = item.info
        (cell as? PairGrillFailureCell)?.iconView.image = item.image
        return cell
    }
}
