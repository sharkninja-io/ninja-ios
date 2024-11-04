//
//  ThermometerSettingsViewController.swift
//  Ninja
//
//  Created by Martin Burch on 2/3/23.
//

import UIKit

class ThermometerSettingsViewController: BaseViewController<ThermometerSettingsView> {
    
    var devicesViewModel: SelectApplianceViewModel = .shared

    var foodCookItem: CookCellItem<Food>?
    var tempCookItem: CookCellItem<FoodPreset>?
    var genericTempCookItem: CookCellItem<UInt32>?
    var howToPlaceItem: CookCellItem<Any>?
    var buttonTitle = "Thermometer"
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    var onSave: ((Food, FoodPreset?, Int?) -> Void)?

    var currentFood: Food? // for switching temperature/preset picker
    var isPrecook: Bool?
    var thermometer: GrillThermometer?

    let modalDelegate = ModalPresentationControllerDelegate(height: 280)

    override func setupViews() {
        super.setupViews()

        subview.tableView.delegate = self
        subview.tableView.dataSource = self

        subview.navBar.backButton.onEvent { [weak self] control in
            self?.navigateBack()
        }
        subview.buttonTitle = buttonTitle
        subview.saveButton.onEvent { [weak self] control in
            self?.saveChanges()
            
        }
        subview.theme = theme
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        foodCookItem?.currentValueSubject.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] food in
            let reload = (self?.currentFood == .Manual && (food != .Manual || food != .NotSet))
                        || (self?.currentFood != .Manual && (food == .Manual || food == .NotSet))
            self?.currentFood = ((food == .NotSet) ? .Manual : food) ?? .Manual
            if reload {
                // TODO: - when switching preset index set on reload whatever food
                self?.subview.tableView.reloadData()
            }
        }).store(in: &disposables)
        devicesViewModel.currentStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self else { return }
            
            self.subview.navBar.pillView.wifiOnline = self.devicesViewModel.isDeviceOnWifi(state: state)
            self.subview.navBar.pillView.bluetoothOnline = self.devicesViewModel.isDeviceOnBT(state: state)
            
            if let state = state {
                if self.isPrecook == nil {
                    self.isPrecook = CookDisplayValues.isPreCookState(state: state.state)
                } else if self.isPrecook != CookDisplayValues.isPreCookState(state: state.state) {
                    self.navigationController?.popViewController(animated: true)
                }
                let pluggedIn = self.isPrecook == true || CookDisplayValues.isPreheatState(state: state.state) || self.thermometer?.pluggedIn == true
                self.subview.setProbeConnected(pluggedIn)
            }
        }.store(in: &disposables)
    }
    
    func getHeaders() -> [String?] {
        return subview.sectionHeaders
    }
    
    func getCellItems() -> [CookItem?] {
        if currentFood == .Manual || currentFood == .Manual {
            return [foodCookItem, genericTempCookItem, howToPlaceItem]
        }
        return [foodCookItem, tempCookItem, howToPlaceItem]
    }
    
    func saveChanges() {
        var protein = foodCookItem?.currentValueSubject.value ?? .Manual
        if protein == .NotSet {
            protein = .Manual
        }
        let doneness = tempCookItem?.currentValueSubject.value
        let temperature = genericTempCookItem?.currentValueSubject.value ?? 0
        onSave?(protein, doneness, Int(temperature))
        navigationController?.popViewController(animated: true)
    }
    
    func navigateBack() {
        if valueChanged() {
            showGoBackModal()
        } else {
            cancelChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func cancelChanges() {
        foodCookItem?.currentValueSubject.send(foodCookItem?.storeValueSubject.value)
        tempCookItem?.currentValueSubject.send(tempCookItem?.storeValueSubject.value)
        genericTempCookItem?.currentValueSubject.send(genericTempCookItem?.storeValueSubject.value)
    }
    
    func valueChanged() -> Bool {
        switch foodCookItem?.currentValueSubject.value {
        case .Manual, .NotSet:
            return (foodCookItem?.currentValueSubject.value != nil && foodCookItem?.currentValueSubject.value != foodCookItem?.storeValueSubject.value)
            || genericTempCookItem?.currentValueSubject.value != genericTempCookItem?.storeValueSubject.value
        default:
            return (foodCookItem?.currentValueSubject.value != nil && foodCookItem?.currentValueSubject.value != foodCookItem?.storeValueSubject.value)
            || tempCookItem?.currentValueSubject.value?.presetIndex != tempCookItem?.storeValueSubject.value?.presetIndex
        }
    }

    private func showGoBackModal() {
        let vc = MonitorControlModalViewController()
        vc.modalTitle = "Want go back?"
        vc.modalDescription = "All changes will be lost. Are you sure you want to discard them?"
        vc.primaryButtonText = "DISCARD CHANGES".uppercased()
        vc.secondaryButtonText = "CANCEL".uppercased()
        vc.successCompletion = { [weak self] in
            guard let self else { return }
            self.cancelChanges()
            self.navigationController?.popViewController(animated: true)
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = modalDelegate
        vc.theme = theme
        vc.isWarning = true
        self.present(vc, animated: true)
    }
}

extension ThermometerSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subview.sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < getHeaders().count, getHeaders()[section] != nil else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CookControlsHeader.VIEW_ID) as? CookControlsHeader
        header?.titleLabel.text = getHeaders()[section]
        header?.theme = theme
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? UITableView.automaticDimension : 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cookItem = getCellItems()[indexPath.section] {
            let cell = tableView.dequeueReusableCell(withIdentifier: cookItem.cell.VIEW_ID, for: indexPath)
            if let cookCell = cell as? CookControlsViewCell {
                cookCell.connectData(data: cookItem)
                cookCell.theme = theme
                cookCell.tableView = tableView
            }
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "EMPTY")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
}
