//
//  ApplianceErrorLogViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/19/22.
//

import UIKit
import GrillCore

class ApplianceErrorLogViewController: BaseViewController<SettingsStandardTableView> {
    
    private let viewModel: SettingsViewModel = .shared()
    
    private var errorList: [GrillCoreSDK.GrillError] = [] { didSet { subview.tableView.reloadData() } }
            
    override func setupViews() {
        subview.setTitles(title: "Appliance Detail".uppercased(), subtitle: "Appliance Error Log")
        
        subview.tableView.dataSource = self
        subview.tableView.delegate = self
        
        errorList = viewModel.currentGrillErrors
    }
    
    private func deselectTableViewCells() {
        if let indexPath = subview.tableView.indexPathForSelectedRow {
            subview.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension ApplianceErrorLogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorLogCell.VIEW_ID, for: indexPath) as? ErrorLogCell else { return UITableViewCell() }
        let item = errorList[indexPath.row]
        cell.applyAttributes(item)
        return cell
    }
}
