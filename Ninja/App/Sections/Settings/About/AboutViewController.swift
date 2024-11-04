//
//  AboutViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

class AboutViewController: BaseViewController<SettingsStandardTableView> {
        
    override func loadView() {
        super.loadView()
        
    }
    
    override func setupViews() {
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
        
        subview.setTitles(subtitle: "About This App")
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
    }
}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewItem.aboutItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.VIEW_ID, for: indexPath) as! SettingsTableViewCell
        let item = SettingsViewItem.aboutItems[indexPath.row]
        cell.connectData(item)
        return cell
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = SettingsViewItem.aboutItems[indexPath.row]
        item.onNavigate?(navigationController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
