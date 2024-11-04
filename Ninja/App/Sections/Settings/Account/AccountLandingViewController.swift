//
//  AccountLandingViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

class AccountLandingViewController: SettingsBaseViewController<SettingsStandardTableView> {
        
    override func loadView() {
        super.loadView()
        
        viewModel.fetchPreferences()
    }
    
    override func setupViews() {
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
        
        subview.setTitles(subtitle: "Account")
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
    }
}

// MARK: Modals
extension AccountLandingViewController {
    func showLogoutModal() {
        let vc = AlertModalViewController(
            title: "Are you sure you want to log out?",
            primaryAction: .init(title: "Log Out", buttonStyle: .destructiveTertiaryButton, alertAction: { [weak self] in
                self?.viewModel.logout()
                self?.deselectTableViewCells()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { [weak self] in self?.deselectTableViewCells() }),
            dismissCallback: { [weak self] in self?.deselectTableViewCells() }
        )
        present(vc, animated: false)
    }
}

extension AccountLandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewItem.accountItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.VIEW_ID, for: indexPath) as! SettingsTableViewCell
        let item = SettingsViewItem.accountItems[indexPath.row]
        cell.connectData(item)
        return cell
    }
}

extension AccountLandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = SettingsViewItem.accountItems[indexPath.row]
        item.onNavigate?(navigationController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = SettingsViewItem.accountItems[indexPath.row]
        if item.description == nil {
            return 55
        } else {
            return 80
        }
    }
}
