//
//  SelectAppliancesViewController.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/16/23.
//

import UIKit

class SelectAppliancesViewController: BaseViewController<SelectApplianceView>, UIGestureRecognizerDelegate {
    
    var viewModel: SelectApplianceViewModel = .shared
    var grills: [Grill] = []

    override func loadView() {
        super.loadView()
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tapToDismiss.delegate = self
        subview.tapToDismissView.isUserInteractionEnabled = true
        subview.tapToDismissView.addGestureRecognizer(tapToDismiss)
        
        subview.navBar.deviceButton.onEvent { [weak self] control in
            self?.dismissView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setupViews() {
        super.setupViews()
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
    }
    
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.grillsSubject.receive(on: DispatchQueue.main).sink { [weak self] grills in
            guard let self = self, let grills = grills else { return }
            self.grills = grills
            self.subview.containerHeightConstraint.constant = CGFloat(grills.count) * self.subview.cellHeightConstant + 35
            self.subview.tableView.reloadData()
        }.store(in: &disposables)
        viewModel.currentGrillSubject.receive(on: DispatchQueue.main).sink { [weak self] grill in
            if let grill = grill {
                self?.subview.navBar.setSelectedDeviceName(name: grill.getName())
            }
            self?.subview.tableView.reloadData()
        }.store(in: &disposables)
        viewModel.currentStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self else { return }
            // TODO: - get bt/wifi states
            self.subview.navBar.pillView.wifiOnline = self.viewModel.isDeviceOnWifi(state: state)
            self.subview.navBar.pillView.bluetoothOnline = self.viewModel.isDeviceOnBT(state: state)
        }.store(in: &disposables)
    }

    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}

extension SelectAppliancesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grills.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return subview.cellHeightConstant
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectApplianceCell.VIEW_ID, for: indexPath)
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        (cell as? SelectApplianceCell)?.hidesTopSeparator = indexPath.row == 0
        (cell as? SelectApplianceCell)?.hidesBottomSeparator = indexPath.row == numberOfRows - 1
        (cell as? SelectApplianceCell)?.nameLabel.text = grills[indexPath.row].getName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedGrill(grill: grills[indexPath.row])
        dismiss(animated: true) // add logic to switch appliances
    }
}
