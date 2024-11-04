//
//  MonitorControlViewController.swift
//  Ninja
//
//  Created by Martin Burch on 2/17/23.
//

import UIKit

class MonitorControlViewController: BaseViewController<MonitorControlView> {
    
    var viewModel: MonitorControlViewModel = .shared
    var devicesViewModel: SelectApplianceViewModel = .shared
    
    var thermometerControls: [CookItem] = []
    var grillControls: [CookItem] = []
    
    let modalDelegate = ModalPresentationControllerDelegate()
    var stateModalShowing = false
    var isOnline = true
    var vc: MonitorControlModalViewController? = nil
    let toastStates = [CalculatedState.GetFood, CalculatedState.FlipFood]
    var thermometerStates: [CalculatedState] = [.Unknown, .Unknown]

    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        subview.navBar.deviceButton.onEvent { [weak self] control in
            self?.expandAppliances()
        }
        subview.cookButton.onEvent { [weak self] control in
            self?.stopCooking(control)
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
        
        viewModel.grillControlsSubject.receive(on: DispatchQueue.main).sink { [weak self] items in
            self?.grillControls = items
            self?.subview.tableView.reloadData()
        }.store(in: &disposables)
        viewModel.thermometerControlsSubject.receive(on: DispatchQueue.main).sink { [weak self] items in
            self?.thermometerControls = items
            self?.subview.tableView.reloadData()
        }.store(in: &disposables)
        viewModel.currentlyWorkingSubject.receive(on: DispatchQueue.main).sink { [weak self] isWorking in
            self?.subview.setProgressIndicator(isOn: isWorking)
        }.store(in: &disposables)
        viewModel.modalSubject.receive(on: DispatchQueue.main).sink { [weak self] type in
            switch type {
            case .ProbeNotPluggedIn(let index):
                self?.showThermometerNotPluggedIn(thermometerIndex: index)
            case .ThermometerCookNotAvailable(let cookMode):
                self?.showThermometerCookNotAvailable(cookMode: cookMode)
            case .ChangeToTimedCook:
                self?.showChangeToTimedCookPopup()
            case .ChangeToThermometerCook:
                self?.showChangeToThermometerCook()
            }
        }.store(in: &disposables)
        
        viewModel.currentCalculatedStateSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self, let state = state else { return }
            
            self.subview.setViewAsDone(isDone: CookDisplayValues.isDoneState(state: state, cookType: self.viewModel.currentCookTypeSubject.value ?? .Unknown))

            // Auto close modals on state change
            if self.stateModalShowing {
                self.vc?.dismiss(animated: true)
                self.stateModalShowing = false
            }
            
            switch state {
            case .AddFood, .FlipFood, .LidOpenDuringCook, .LidOpenBeforeCook:
                self.showToast(state: state)
            case .PlugInProbe1, .PlugInProbe2:
                self.showThermometerNotPluggedIn(thermometerIndex: state == .PlugInProbe1 ? 0 : 1) {
                    self.stateModalShowing = false
                }
                self.stateModalShowing = true
            default:
                break
            }
            
            self.subview.tableView.reloadData()
        }.store(in: &disposables)
        viewModel.availableThermometersSubject.receive(on: DispatchQueue.main).sink { [weak self] thermometers in
            guard let self = self,
                  let state1 = thermometers.first?.grillThermometer?.state,
                  let state2 = thermometers.last?.grillThermometer?.state else { return }
            
            // TOASTS
            if self.toastStates.contains(state1), self.thermometerStates[0] != state1 {
                self.showToast(state: state1, index: 0)
            } else if self.toastStates.contains(state2), self.thermometerStates[1] != state2 {
                self.showToast(state: state2, index: 1)
            }
            
            // DIALOGS
            let selectedThermometer = thermometers.first { $0.isSelected }
            if selectedThermometer?.index == 0, state2 == .Done, self.thermometerStates[1] != .Done {
                self.showThermometerComplete(index: 1)
            } else if selectedThermometer?.index == 1, state1 == .Done, self.thermometerStates[0] != .Done {
                self.showThermometerComplete(index: 0)
            }
            self.thermometerStates = [state1, state2]
        }.store(in: &disposables)
        viewModel.currentGrillProgressSubject.removeDuplicates(by: { pair1, pair2 in
            if let pair1 = pair1, let pair2 = pair2 {
                return pair1.0 == pair2.0 && pair1.1 == pair2.1
            }
            return false
        }).receive(on: DispatchQueue.main).sink { [weak self] progress in
            guard let self = self else { return }
            if let progress = progress {
                self.setBackgroundColor(progress: progress.0, state: progress.1, online: self.devicesViewModel.isDeviceConnected(state: self.viewModel.currentGrillStateSubject.value))
            }
        }.store(in: &disposables)
        
        devicesViewModel.currentGrillSubject.receive(on: DispatchQueue.main).sink { [weak self] grill in
            if let grill = grill {
                self?.viewModel.currentlyWorkingSubject.send(false) // TODO: - FIX FOR SPINNER
                let name = grill.getName()
                self?.subview.navBar.setSelectedDeviceName(name: name)
            }
        }.store(in: &disposables)
        devicesViewModel.currentStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self else { return }
            
            if let state = state {
                self.setCookTypeTab(cookType: state.cookType)
                if CookDisplayValues.isPreCookState(state: state.state) {
                    self.toPrecook()
                }
                let onlineStatus = self.devicesViewModel.isDeviceConnected(state: state)
                if onlineStatus != self.isOnline {
                    if !onlineStatus && NotificationService.shared.allSubscribedSubject.value {
                        self.sendOfflineNotification()
                    }
                    self.setBackgroundColor(
                        progress: self.viewModel.currentGrillProgressSubject.value?.0 ?? 0,
                        state: self.viewModel.currentGrillProgressSubject.value?.1 ?? .Unknown,
                        online: onlineStatus)
                    self.isOnline = onlineStatus
                }
            }
            self.subview.navBar.pillView.wifiOnline = self.devicesViewModel.isDeviceOnWifi(state: state)
            self.subview.navBar.pillView.bluetoothOnline = self.devicesViewModel.isDeviceOnBT(state: state)
        }.store(in: &disposables)
    }
    
    func setBackgroundColor(progress: UInt, state: CalculatedState, online: Bool? = true) { // 0.0 -> 100.0
        if online == false {
            self.subview.setBackgroundGradient(endColor: ColorThemeManager.shared.monitorControlTheme.black01)
        } else {
            let colorState: CalculatedState = state == .LidOpenDuringCook || state == .LidOpenBeforeCook ? .Cooking : state
            let colors = MonitorControlColors.getColorSet(state: colorState).gradientColors
            let endColor = UIColor.getColorFromGradientAt(colors: colors, percent: CGFloat(progress) / 100.0)
            self.subview.setBackgroundGradient(endColor: endColor)
        }
    }
    
    func setCookTypeTab(cookType: CookType) {
        viewModel.currentCookTypeSubject.send(cookType)
    }
    
    func setCookType(cookType: CookType) {
        viewModel.currentCookTypeSubject.send(cookType)
    }
    
    func setCookMode(cookMode: CookMode) {
        viewModel.currentCookModeSubject.send(cookMode)
    }
    
    func showToast(state: CalculatedState, index: Int = 0) {
        switch state {
        case .AddFood:
            subview.showToast(
                icon: IconAssetLibrary.ico_fire_flame.asTemplateImage() ?? UIImage(),
                title: "Add Food",
                message: "Your grill is preheated and ready to go",
                colors: MonitorControlColors.getColorSet(state: .Cooking).toastColors
            )
        case .FlipFood:
            subview.showToast(
                icon: IconAssetLibrary.ico_flip_arrow.asTemplateImage() ?? UIImage(),
                title: "Time to Flip",
                message: "We're halfway through your cook",
                colors: MonitorControlColors.getColorSet(state: .Cooking).toastColors
            )
//        case .Cooking:
//            subview.showToast(
//                icon: IconAssetLibrary.ico_grill.asTemplateImage() ?? UIImage(),
//                title: "Ready to Go",
//                message: "Grill temperature of <temp> has been reached.",
//                colors: MonitorControlColors.getColorSet(state: .Cooking).toastColors
//            )
        case .GetFood:
            subview.showToast(
                icon: IconAssetLibrary.ico_remove_arrow.asTemplateImage() ?? UIImage(),
                title: "Remove Food",
                message: "Thermometer \(index + 1): Remove from the grill and allow it to rest. It will continue to cook with residual heat to reach the set temperature.",
                colors: MonitorControlColors.getColorSet(state: .Resting).toastColors
            )
        case .LidOpenDuringCook, .LidOpenBeforeCook:
            subview.showToast(
                icon: IconAssetLibrary.ico_error.asTemplateImage() ?? UIImage(),
                title: "Close Lid",
                message: "The cook will not continue until the lid is closed.",
                colors: MonitorControlColors.getColorSet(state: .LidOpenDuringCook).toastColors
            )
        default:
            break
        }
    }
    
    func sendOfflineNotification() {
        NotificationService.shared.createLocalNotification(title: "Connection Lost", message: "Your appliance has lost its Wi-Fi connection. Ensure you have Wi-Fi turned on and that the appliance is within range.")
    }
    
    func getHeaders() -> [String?] {
        if thermometerControls.isEmpty {
            return subview.noThermSectionHeaders
        } else {
            return subview.sectionHeaders
        }
    }
    
    func getItems(section: Int) -> [CookItem?] {
        switch section {
        case 0:
            return [viewModel.cookTypeCell]
        case 1:
            return [viewModel.progressCell]
        case 2:
            return thermometerControls.isEmpty ? grillControls : thermometerControls
        case 3:
            return grillControls
        default:
            return []
        }
    }
    
    func toPrecook() {
        navigationController?.popToViewController(toControllerType: PreCookViewController.self, animated: true)
    }
    
    func expandAppliances() {
        let vc = UINavigationController(rootViewController: SelectAppliancesViewController())
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    func stopCooking(_ sender: UIControl) {
        viewModel.stopCooking()
    }
}

extension MonitorControlViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getHeaders().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItems(section: section).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = getHeaders()[section] {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CookControlsHeader.VIEW_ID) as? CookControlsHeader
            header?.theme = { ColorThemeManager.shared.monitorControlTheme }
            header?.titleLabel.text = title
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: CookItem? = getItems(section: indexPath.section)[indexPath.row]
        if let item = item {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cell.VIEW_ID, for: indexPath)
            if let cookCell = cell as? CookControlsViewCell {
                cookCell.connectData(data: item)
                cookCell.theme = { ColorThemeManager.shared.monitorControlTheme }
                cookCell.tableView = tableView // TODO: - allow for resizing
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: CookItem? = getItems(section: indexPath.section)[indexPath.row]
        if CookDisplayValues.isUpdateState(state: viewModel.currentCalculatedStateSubject.value ?? .Unknown),
            let navigationController = navigationController,
            let item = item,
            let navigate = item.onNavigate {
            navigate(navigationController, self)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
}

extension MonitorControlViewController {
    
    func showChangeToTimedCookPopup() {
        showModal(
            title: "Want to change to Timed Cook?",
            description: "Your cook will complete when the timer runs out, rather than when your thermometers meet their target temperatures. You will lose your thermometer settings.",
            primaryText: "Continue to Timed Cook".uppercased(),
            secondaryText: "Cancel".uppercased(),
            delegate: modalDelegate,
            completion: { [weak self] in
                if let viewController = self?.viewModel.getTimeTemperatureSettingsVC(mode: .ModeTimeTemp, cookType: CookType.Timed) {
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }, cancelCompletion: { [weak self] in
                self?.setCookTypeTab(cookType: self?.viewModel.currentCookTypeSubject.value ?? .ProbeSingle)
            })
    }
    
    func showChangeToThermometerCook() {
        showModal(
            title: "Want to set a thermometer?",
            description: "You are about to change the cooking control type, you will have to add new settings. The grill will no longer operate on a timed setting.",
            primaryText: "Yes, add a thermometer".uppercased(),
            secondaryText: "Cancel".uppercased(),
            delegate: modalDelegate,
            completion: { [weak self] in
                guard let self = self else { return }
                
                let thermometer = self.viewModel.availableThermometersSubject.value.first(where: { $0.grillThermometer?.pluggedIn ?? false }) ?? self.viewModel.availableThermometersSubject.value[0]
                let viewController = self.viewModel.getThermometerSettingsVC(thermometer: thermometer)
                self.navigationController?.pushViewController(viewController, animated: true)
            }, cancelCompletion: { [weak self] in
                self?.setCookTypeTab(cookType: self?.viewModel.currentCookTypeSubject.value ?? .ProbeSingle)
            })
    }
    
//    func showNoThermometerPluggedIn(completion: (() -> Void)?) {
//        showModal(
//            title: "Thermometer not plugged in.",
//            description: "At least one thermometer must be plugged into the grill to use thermometer mode.",
//            primaryText: "Back to Timed Cook".uppercased(),
//            secondaryText: nil,
//            delegate: modalDelegate,
//            height: 250,
//            completion: completion)
//    }
    
    func showThermometerNotPluggedIn(thermometerIndex: Int, completion: (() -> Void)? = nil) {
        showModal(
            title: "Thermometer not plugged in.",
            description: "Your \(thermometerIndex == 0 ? "first" : "second") thermometer must be plugged in to track its readings.",
            primaryText: "Okay".uppercased(),
            secondaryText: nil,
            delegate: modalDelegate,
            height: 250,
            completion: completion)
    }
    
    func showThermometerComplete(index: Int, completion: (() -> Void)? = nil) {
        showModal(
            title: "Cook Complete",
            description: "Thermometer \(index + 1): We’ve reached your set resting temperature.",
            primaryText: "Check it out".uppercased(),
            secondaryText: "Okay".uppercased(),
            delegate: modalDelegate,
            height: 280,
            completion: { [weak self] in
                self?.viewModel.availableThermometersSubject.value.enumerated().forEach({ (itemIndex, thermometer) in
                    thermometer.isSelected = (index == itemIndex)
                })
            })
    }
    
    func showThermometerCookNotAvailable(cookMode: CookMode) {
        showModal(
            title: "Not Supported",
            description: "Dehydrate and Broil cooking modes do not support thermometer cooking. Try changing the cook mode if you’d like to monitor thermometers.",
            primaryText: "Okay".uppercased(),
            secondaryText: nil,
            delegate: modalDelegate,
            height: 280,
            completion: nil
        )
    }

//    func showTimesUpModal(grillName: String, completion: (() -> Void)? = nil) {
//        showModal(
//            title: "Time’s up!",
//            description: "\(grillName) has completed its cook.",
//            primaryText: "Let’s check it out".uppercased(),
//            secondaryText: "Gotcha".uppercased(),
//            delegate: modalDelegate,
//            height: 250,
//            completion: completion)
//    }
    
    private func showModal(title: String, description: String, primaryText: String?, secondaryText: String?, delegate: ModalPresentationControllerDelegate, height: CGFloat = 350, completion: (() -> Void)?, cancelCompletion: (() -> Void)? = nil) {
        vc = MonitorControlModalViewController()
        if let vc = vc {
            vc.modalTitle = title
            vc.modalDescription = description
            vc.primaryButtonText = primaryText
            vc.secondaryButtonText = secondaryText
            vc.successCompletion = completion
            vc.cancelCompletion = cancelCompletion
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = delegate
            vc.theme = { ColorThemeManager.shared.monitorControlTheme }
            delegate.dismissCompletion = cancelCompletion
            delegate.height = height
            self.present(vc, animated: true)
        }
    }

}
