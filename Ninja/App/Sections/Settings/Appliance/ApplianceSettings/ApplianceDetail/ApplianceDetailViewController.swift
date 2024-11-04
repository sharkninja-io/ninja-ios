//
//  ApplianceDetailViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

class ApplianceDetailViewController: BaseViewController<SettingsStandardTableView> {
    
    private let viewModel: SettingsViewModel = .shared()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectTableViewCells()
    }
    
    override func subscribeToSubjects() {
        viewModel.factoryResetSubject.sink { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.subview.completeLoadingOverlay() {
                        self?.navigationController?.popToViewController(toControllerType: ApplianceDetailViewController.self, animated: true)
                    }
                } else {
                    self?.subview.interruptLoadingOverlay() {
                        self?.showResetFailureModal()
                    }
                }
            }
        }.store(in: &disposables)
        
        viewModel.applianceDeletedSubject.sink { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.subview.completeLoadingOverlay() {
                        self?.navigationController?.popToViewController(toControllerType: ApplianceLandingViewController.self, animated: true)
                    }
                } else {
                    self?.subview.interruptLoadingOverlay() {
                        let vc = AlertModalViewController(title: "Something Went Wrong", description: "Please try again later.", primaryAction: .init(title: "OK", buttonStyle: .primaryButton, alertAction: {}))
                        self?.present(vc, animated: true)
                    }
                }
            }
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        subview.setTitles(title: viewModel.currentGrillSubject.value?.getName(), subtitle: "Appliance Detail")
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
    }
    
    private func deselectTableViewCells() {
        if let indexPath = subview.tableView.indexPathForSelectedRow {
            subview.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func startFactoryReset() {
        viewModel.restoreFactorySettings()
        subview.startLoadingOverlay()
    }
    
    private func startDeleteAppliance() {
        viewModel.deleteAppliance()
        subview.startLoadingOverlay()
    }
}

// MARK: Modals
extension ApplianceDetailViewController {
    func showResetFailureModal() {
        let vc = AlertModalViewController(
            title: "Oops, something went wrong!",
            description: "The restore attempt has failed. Try again?",
            primaryAction: .init(title: "Retry", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                self?.startFactoryReset()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { return }),
            dismissCallback: { [weak self] in self?.deselectTableViewCells() }
        )
        present(vc, animated: false)
    }
    
    func showFactoryResetModal() {
        let vc = AlertModalViewController(
            title: "Are you sure you want to reset your device to factory settings?",
            description: "This cannot be undone and may take a moment to complete.",
            primaryAction: .init(title: "Restore Factory Settings", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                self?.startFactoryReset()
                self?.deselectTableViewCells()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { [weak self] in self?.deselectTableViewCells() }),
            dismissCallback: { [weak self] in self?.deselectTableViewCells() }
        )
        present(vc, animated: false)
    }
    
    func showDeleteApplianceModal() {
        let vc = AlertModalViewController(
            title: "Are you sure you want to delete your appliance?",
            description: "This cannot be undone and may take a moment to copmlete.",
            primaryAction: .init(title: "Delete Appliance", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                self?.startDeleteAppliance()
                self?.deselectTableViewCells()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { [weak self] in self?.deselectTableViewCells() }),
            dismissCallback: { [weak self] in self?.deselectTableViewCells() }
        )
        present(vc, animated: false)
    }
}

extension ApplianceDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // Detail Cells
            return ApplianceDetailViewController.DetailCellField.allCases.count
        } else { // Action Cells
            return SettingsViewItem.applianceDetailItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // Detail Cells
            let cell = tableView.dequeueReusableCell(withIdentifier: ApplianceDetailCell.VIEW_ID, for: indexPath)
            (cell as? ApplianceDetailCell)?.connectData(indexPath.row)
            return cell
            
        } else { // Action Cells
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.VIEW_ID, for: indexPath)
            let item = SettingsViewItem.applianceDetailItems[indexPath.row]
            (cell as? SettingsTableViewCell)?.connectData(item)
            return cell
        }
    }
}

extension ApplianceDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let item = SettingsViewItem.applianceDetailItems[indexPath.row]
        item.onNavigate?(navigationController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
