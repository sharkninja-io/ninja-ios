//
//  ApplianceSettingsViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

class ApplianceSettingsViewController: BaseViewController<SettingsStandardTableView> {
    
    private let viewModel: SettingsViewModel = .shared()
    
    override func setupViews() {
        subview.setTitles(title: "Your Appliance".uppercased(), subtitle: viewModel.currentGrillSubject.value?.getName())
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        viewModel.currentGrillSubject.receive(on: DispatchQueue.main).sink { [weak self] grill in
            self?.subview.subtitleLabel.text = grill?.getName()
        }.store(in: &disposables)
    }
}

extension ApplianceSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewItem.applianceItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.VIEW_ID, for: indexPath) as! SettingsTableViewCell
        let item = SettingsViewItem.applianceItems[indexPath.row]
        cell.connectData(item)
        
        if item.itemStyle == .toggle {
            cell.settingSwitch.isOn = viewModel.grillNoticiationsEnabled ?? false
            cell.settingSwitch.onEvent(for: .valueChanged) { [weak self] _ in
                self?.viewModel.toggleGrillNotifications()
            }
        }
        
        return cell
    }
}

extension ApplianceSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = SettingsViewItem.applianceItems[indexPath.row]
        item.onNavigate?(navigationController)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
