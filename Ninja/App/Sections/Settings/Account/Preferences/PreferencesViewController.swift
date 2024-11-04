//
//  PreferencesViewController.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 9/27/22.
//

import UIKit

class PreferencesViewController: BaseViewController<SettingsStandardTableView> {
            
    override func setupViews() {
        subview.setTitles(title: "Profile", subtitle: "Preferences")
        
        subview.tableView.separatorStyle = .none
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
    }
    
}

extension PreferencesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PreferencesItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldCell.VIEW_ID, for: indexPath) as! ProfileTextFieldCell
        let item = PreferencesItem.allCases[indexPath.row]
        cell.connectData(item)
        
        return cell
    }
}

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProfileTextFieldCell
        let item = PreferencesItem.allCases[indexPath.row]
        let vc = SimplePickerViewController(item) { itemProperty in
            item.setItemProperty(itemProperty)
            cell.textField.text = itemProperty
        }
        vc.modalPresentationStyle = .overFullScreen
        
        present(vc, animated: false)
    }
}
