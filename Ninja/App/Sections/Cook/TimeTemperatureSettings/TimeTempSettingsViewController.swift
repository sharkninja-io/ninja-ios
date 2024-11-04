//
//  TimeTempSettingsViewController.swift
//  Ninja
//
//  Created by Martin Burch on 2/3/23.
//

import UIKit

class TimeTempSettingsViewController: BaseViewController<TimeTempSettingsView> {
    
    enum SettingsMode {
        case TimeTemp
        case Temp
        case ModeTimeTemp
        case ModeTemp
    }
    
    var currentMode: SettingsMode = .TimeTemp {
        didSet {
            if currentMode == .TimeTemp {
                initCookingCharts()
            }
        }
    }

    var devicesViewModel: SelectApplianceViewModel = .shared

    var currentCookMode: CookMode = .NotSet
    let cookChartViewModel: CookingChartsViewModel = .shared()
    var cookingChartsItem: CookItem? = nil
    var showCookingChartsCTA: Bool = false
    var isPrecook: Bool?
    
    var modeCookItem: CookCellItem<CookMode>?
    var timeCookItem: CookCellItem<UInt32>?
    var tempCookItem: CookCellItem<UInt32>?
    var onSave: ((CookMode, Int, Int) -> Void)? = nil
    var onCancel: (() -> Void)? = nil
    var isValueChanged: (() -> Bool)? = nil
    var buttonTitle = "Settings"
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }

    let modalDelegate = ModalPresentationControllerDelegate(height: 280)

    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self

        subview.navBar.backButton.onEvent { [weak self] control in
            self?.navigateBack()
        }
        
        subview.navBar.backButton.setTitle("\(buttonTitle) Settings", for: .normal)
        subview.saveButton.onEvent { [weak self] control in
            self?.saveChanges()
            
        }
        
        subview.theme = theme
        
        if onCancel == nil {
            onCancel = cancelChanges
        }
        if isValueChanged == nil {
            isValueChanged = valueChanged
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
    }

    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
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
            }
        }.store(in: &disposables)
    }
    
    func initCookingCharts() {
        showCookingChartsCTA = cookChartViewModel.hasCookMode(cookMode: currentCookMode)
        cookingChartsItem = CookItem(cell: CookingChartsCTACell.self, onNavigate: { [weak self] navigationController, viewController in
            guard let self = self else { return }
            self.cookChartViewModel.setCookModeAndValidFoodCategories(cookMode: self.currentCookMode)
            let vc = UINavigationController(rootViewController: CookingChartGalleryViewController())
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        })
    }
    
    func getHeaders() -> [String?] {
        switch currentMode {
        case .TimeTemp:
            var headers: [String?] = [subview.sectionHeaders[1], subview.sectionHeaders[2]]
            if showCookingChartsCTA {
                headers.insert(nil, at: 0)
            }
            return headers
        case .Temp:
            return [subview.sectionHeaders[2]]
        case .ModeTimeTemp:
            return subview.sectionHeaders
        case .ModeTemp:
            return [subview.sectionHeaders[0], subview.sectionHeaders[2]]
        }
    }
    
    func getCellItems() -> [CookItem?] {
        switch currentMode {
        case .TimeTemp:
            var cells: [CookItem?] = [timeCookItem, tempCookItem]
            if showCookingChartsCTA {
                cells.insert(cookingChartsItem, at: 0)
            }
            return cells
        case .Temp:
            return [tempCookItem]
        case .ModeTimeTemp:
            return [modeCookItem, timeCookItem, tempCookItem]
        case .ModeTemp:
            return [modeCookItem, tempCookItem]
        }
    }
    
    func saveChanges() {
        let mode = modeCookItem?.currentValueSubject.value ?? .Unknown
        let temperature = tempCookItem?.currentValueSubject.value ?? 0
        let duration = timeCookItem?.currentValueSubject.value ?? 0
        onSave?(mode, Int(temperature), Int(duration))
        navigationController?.popViewController(animated: true)
    }
    
    func navigateBack() {
        if isValueChanged?() ?? false {
            showGoBackModal()
        } else {
            onCancel?()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func cancelChanges() {
        modeCookItem?.currentValueSubject.send(modeCookItem?.storeValueSubject.value)
        tempCookItem?.currentValueSubject.send(tempCookItem?.storeValueSubject.value)
        timeCookItem?.currentValueSubject.send(timeCookItem?.storeValueSubject.value)
    }
    
    func valueChanged() -> Bool {
        return modeCookItem?.currentValueSubject.value != modeCookItem?.storeValueSubject.value
        || tempCookItem?.currentValueSubject.value != tempCookItem?.storeValueSubject.value
        || timeCookItem?.currentValueSubject.value != timeCookItem?.storeValueSubject.value
    }

    private func showGoBackModal() {
        let vc = MonitorControlModalViewController()
        vc.modalTitle = "Want go back?"
        vc.modalDescription = "All changes will be lost. Are you sure you want to discard them?"
        vc.primaryButtonText = "DISCARD CHANGES".uppercased()
        vc.secondaryButtonText = "CANCEL".uppercased()
        vc.successCompletion = { [weak self] in
            guard let self else { return }
            self.onCancel?()
            self.navigationController?.popViewController(animated: true)
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = modalDelegate
        vc.theme = theme
        vc.isWarning = true
        self.present(vc, animated: true)
    }
    
    func navigateToCookingCharts() {
        let vc = UINavigationController(rootViewController: CookingChartGalleryViewController())
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

extension TimeTempSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getHeaders().count
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
        return 32
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cookItem = getCellItems()[indexPath.section],
            let navigate = cookItem.onNavigate,
            let navigationController = navigationController {
            navigate(navigationController, self)
        }
    }

}
