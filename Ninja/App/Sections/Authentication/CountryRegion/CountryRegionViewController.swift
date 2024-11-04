//
//  CountryRegionViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/19/22.
//

import UIKit

class CountryRegionViewController: BaseViewController<CountryRegionView> {
    
    private var viewModel: AuthenticationViewModel = .shared()
    private var countryRegionManager: CountryRegionManager = .shared
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.continueButton.onEvent{ [weak self] _ in self?.toCreateAccount() }
    }
    
    internal func selectCountryRegion(_ countryRegion: CountryRegionSupport) {
        viewModel.setCountryRegion(countryRegion: countryRegion)
        subview.continueButton.isEnabled = true
    }
    
    private func toCreateAccount() {
        navigationController?.pushViewController(CreateAccountFormViewController(), animated: true)
    }
}

extension CountryRegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryRegionManager.countryRegionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryRegionViewCell.VIEW_ID, for: indexPath)
        let name = countryRegionManager.countryRegionList[indexPath.row].name
        (cell as? CountryRegionViewCell)?.nameLabel.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CountryRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < countryRegionManager.countryRegionList.count {
            selectCountryRegion(countryRegionManager.countryRegionList[indexPath.row])
        }
    }
}
