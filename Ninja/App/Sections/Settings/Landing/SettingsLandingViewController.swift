//
//  SettingsViewController.swift
//  Ninja
//
//  Created by Martin Burch on 8/21/22.
//

import UIKit

class SettingsLandingViewController: SettingsBaseViewController<SettingsLandingView> {
    
    var notificationsEnabled = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = subview.tableView.indexPathForSelectedRow {
            subview.tableView.deselectRow(at: indexPath, animated: true)
        }
        hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false
        
        if subview.isSpinning {
            subview.startLoadingOverlay() // restart spinning on navigation
        }
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.notificationsWorkingSubject.receive(on: DispatchQueue.main).sink { [weak self] isWorking in
            if isWorking {
                self?.subview.startLoadingOverlay()
            } else {
                self?.subview.interruptLoadingOverlay()
            }
        }.store(in: &disposables)
        
        viewModel.notificationsEnabledSubject.receive(on: DispatchQueue.main).sink { [weak self] status in
            self?.notificationsEnabled = status
            self?.subview.tableView.reloadData()
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
    }
}

extension SettingsLandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewItem.landingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.VIEW_ID, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        let item = SettingsViewItem.landingItems[indexPath.row]
        cell.connectData(item)
        
        if item.itemStyle == .toggle { // Notifications Cell
            cell.settingSwitch.removeEvent(for: .valueChanged)
            cell.settingSwitch.isOn = notificationsEnabled
            cell.settingSwitch.onEvent(for: .valueChanged) { [weak self] _ in
                guard let self else { return }
                Task {
                    let denied = await self.viewModel.hasDeniedPushNotifications()
                    if !cell.settingSwitch.isOn || !denied {
                        await self.viewModel.setCookingNotifications(enabled: cell.settingSwitch.isOn)
                    } else {
                        await MainActor.run {
                            self.showGoToNotificationSettingsModal()
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

extension SettingsLandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = SettingsViewItem.landingItems[indexPath.row]
        item.onNavigate?(navigationController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = SettingsViewItem.landingItems[indexPath.row]
        if item.description == nil {
            return 55
        } else {
            return 80
        }
    }
}

// MARK: Modals
extension SettingsLandingViewController {
    func showGoToNotificationSettingsModal() {
        let vc = AlertModalViewController(
            title: "Change Notification Settings",
            description: "You need to allow this app to send push notifications to use this feature.",
            primaryAction: .init(title: "Go To Settings".uppercased(), buttonStyle: .primaryButton, alertAction: { [weak self] in
                guard let self, let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
                self.subview.tableView.reloadData()
            }),
            secondaryAction: .init(title: "Cancel".uppercased(), buttonStyle: .secondaryButton, alertAction: { [weak self] in
                self?.notificationsEnabled = false
                self?.subview.tableView.reloadData()
            }),
            preventDismissalWithoutAction: true
        )
        present(vc, animated: true)
    }
}
