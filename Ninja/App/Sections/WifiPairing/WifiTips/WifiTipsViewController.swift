//
//  WifiTipsViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class WifiTipsViewController: BaseViewController<WifiTipsView> {
    
    override func setupViews() {
        super.setupViews()

        subview.tableView.delegate = self
        subview.tableView.dataSource = self
    }
    
    func toNext(_ control: UIControl) {
        self.dismiss(animated: true)
    }

}

extension WifiTipsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WifiTipsItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WifiTipsViewCell.VIEW_ID, for: indexPath)
        (cell as? WifiTipsViewCell)?.titleLabel.text = WifiTipsItem.items[indexPath.row].title
        (cell as? WifiTipsViewCell)?.infoLabel.text = WifiTipsItem.items[indexPath.row].description
        return cell
    }
    
}
