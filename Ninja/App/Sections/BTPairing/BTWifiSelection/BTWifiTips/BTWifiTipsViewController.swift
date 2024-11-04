//
//  BTWifiTipsViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/3/23.
//

import Foundation

import UIKit

class BTWifiTipsViewController: BaseViewController<BTWifiTipsView> {
    
    override func setupViews() {
        super.setupViews()

        subview.tableView.delegate = self
        subview.tableView.dataSource = self
    }
    
    func toNext(_ control: UIControl) {
        self.dismiss(animated: true)
    }

}

extension BTWifiTipsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BTWifiTipsItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTWifiTipsCell.VIEW_ID, for: indexPath)
        (cell as? BTWifiTipsCell)?.titleLabel.text = BTWifiTipsItem.items[indexPath.row].title
        (cell as? BTWifiTipsCell)?.infoLabel.text = BTWifiTipsItem.items[indexPath.row].description
        return cell
    }
    
}
