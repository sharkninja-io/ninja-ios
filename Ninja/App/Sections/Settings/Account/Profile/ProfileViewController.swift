//
//  ProfileViewController.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 9/27/22.
//

import UIKit

class ProfileViewController: BaseViewController<ProfileView> {
    
    private let viewModel: SettingsViewModel = .shared()
        
    // MARK: Profile Properties
    /// Returns `true` if all required values are neither `nil` nor empty strings
    private var formIsValid: Bool {
        !(viewModel.userProfileDraft?.firstName?.isEmpty ?? true) &&
        !(viewModel.userProfileDraft?.lastName?.isEmpty ?? true) &&
        !(viewModel.userProfileDraft?.preferredShipToAddress?.addressLine1?.isEmpty ?? true) &&
        !(viewModel.userProfileDraft?.preferredShipToAddress?.city?.isEmpty ?? true) &&
        !(viewModel.userProfileDraft?.preferredShipToAddress?.state?.isEmpty ?? true) &&
        !(viewModel.userProfileDraft?.preferredShipToAddress?.postalCode?.isEmpty ?? true)
    }
    private var changesPresent: Bool = false
    private var phoneNumberDelegate = ProfilePhoneNumberTextFieldDelegate(country: .current)
    
    override func loadView() {
        super.loadView()
        
        keyboardSizeObserverDelegate = ProfileKeyboardObserverDelegate(vc: self)
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.profileChangesSubject.receive(on: DispatchQueue.main).sink { [weak self] changesPresent in
            guard let self else { return }
            self.changesPresent = changesPresent
            self.subview.saveChangesButton.isEnabled = changesPresent && self.formIsValid
        }.store(in: &disposables)
    }
    
    override func setupViews() {
        subview.setTitles(title: "Account", subtitle: "Profile")
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
        
        subview.saveChangesButton.isEnabled = false
        
        subview.saveChangesButton.onEvent() { [weak self] _ in
            guard let self else { return }
            self.saveChanges()
        }
    }
        
    override func backButtonBehavior() {
        if changesPresent {
            if formIsValid {
                showConfirmChanges()
            } else {
                viewModel.resetProfileChanges()
                navigationController?.popViewController(animated: true)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveChanges() {
        viewModel.updateProfile()
        navigationController?.popViewController(animated: true)
    }
    
    private func toDeleteAccount() {
        viewModel.deleteAccount()
        let vc = DeletingAccountLoadingViewController(completionMessage: "Your account has been deleted! Hope to see you soon!")
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: TableView
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileManager.relevantCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != ProfileManager.relevantCases.count else {
            // Add footer/delete account cell
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileFooterCell.VIEW_ID, for: indexPath)
            (cell as? ProfileFooterCell)?.deleteAccountButton.onEvent() { [weak self] _ in self?.showDeleteAccountModal() }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldCell.VIEW_ID, for: indexPath) as? ProfileTextFieldCell else { return UITableViewCell() }
        let item = ProfileManager.relevantCases[indexPath.row]
        cell.connectData(withProfileItem: item, parent: self)
        
        if item == .phoneNumber { // Give the phoneNumber field its own delegate.
            cell.textField.delegate = phoneNumberDelegate
        } else {
            cell.textField.delegate = cell
        }
        
        return cell
    }    
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != ProfileManager.relevantCases.count else { return }
        
        let item = ProfileManager.relevantCases[indexPath.row]
        guard item == .state,
              let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell,
              let nextCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? ProfileTextFieldCell else { return }
        
        let vc = SimplePickerViewController(item) { itemProperty in
            item.updateLocalModel(itemProperty)
            cell.textField.text = itemProperty
            nextCell.textField.becomeFirstResponder()
        }
        vc.modalPresentationStyle = .overFullScreen
        
        present(vc, animated: false)
    }
}

// MARK: Modals
extension ProfileViewController {
    private func showConfirmChanges() {
        let vc = AlertModalViewController(
            title: "You have unsaved changes.",
            description: "Would you like to save?",
            primaryAction: .init(title: "Save Changes", buttonStyle: .primaryButton, alertAction: { [weak self] in
                guard let self else { return }
                self.subview.saveChangesButton.isEnabled = false
                self.saveChanges()
                self.navigationController?.popViewController(animated: true)
            }),
            secondaryAction: .init(title: "Discard Changes", buttonStyle: .destructiveSecondaryButton, alertAction: { [weak self] in
                guard let self else { return }
                self.viewModel.resetProfileChanges()
                self.navigationController?.popViewController(animated: true)
            }),
            dismissCallback: { return }
        )
        present(vc, animated: true)
    }
    
    private func showDeleteAccountModal() {
        let vc = AlertModalViewController(
            title: "Are you sure you want to delete your account?",
            description: "This cannot be undone and may take a moment to complete.",
            primaryAction: .init(title: "Delete my account", buttonStyle: .destructivePrimaryButton, alertAction: { [weak self] in
                guard let self else { return }
                self.toDeleteAccount()
            }),
            secondaryAction: .init(title: "Cancel", buttonStyle: .secondaryButton, alertAction: { return })
        )
        present(vc, animated: false)
    }
}

// MARK: Keyboard Observer
extension ProfileViewController {
    private class ProfileKeyboardObserverDelegate: KeyboardSizeObserverDelegate {
        let keyboardSuggestionBarPadding: Int
        private weak var vc: ProfileViewController?
        init(vc: ProfileViewController, keyboardPadding: Int = 32) {
            self.vc = vc
            self.keyboardSuggestionBarPadding = keyboardPadding
        }
        
        func keyboardWillShow(_ rect: CGRect) {
            guard let vc, let currentCell = vc.subview.tableView.visibleCells.first(where: {($0 as! ProfileTextFieldCell).textField.isFirstResponder}) as? ProfileTextFieldCell else { return }
            let keyboardTop = rect.height
            let cellBottom = currentCell.frame.maxY
            let translation = keyboardTop - cellBottom - 32
            if translation < 0 {
                UIView.animate(withDuration: 0.2) {
                    vc.subview.tableView.transform = .init(translationX: 0, y: translation)
                }
            }
        }
        
        func keyboardWillHide(_ rect: CGRect) {
            guard let vc else { return }
            UIView.animate(withDuration: 0.2) {
                vc.subview.tableView.transform = .identity
            }
        }
    }
}
