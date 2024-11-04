//
//  CookViewController.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit
import Combine

class PreCookViewController: BaseViewController<PreCookView> {
    
    var viewModel: PreCookViewModel = .shared
    var devicesViewModel: SelectApplianceViewModel = .shared
    var cookingChartsViewModel: CookingChartsViewModel = .shared()
    var menuViewModel: MenuTabBarViewModel = .shared()

    private var vc: MonitorControlModalViewController?
    private let modalDelegate = ModalPresentationControllerDelegate()

    var currentControls: [CookItem] = []
    
    override func setupViews() {
        super.setupViews()
        
        subview.tableView.delegate = self
        subview.tableView.dataSource = self
        
        cookingChartsViewModel.delegate = self 
        
        subview.navBar.deviceButton.onEvent { [weak self] _ in
            self?.expandAppliances()
        }
        subview.cookButton.onEvent{ [weak self] _ in self?.startCooking() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if menuViewModel.shouldDisplayReviewModal() {
            showReviewRequestModal()
            menuViewModel.setDisplayedReviewModalDate()
        }
    }
    
    override func subscribeToSubjects() {
        super.subscribeToSubjects()
        
        viewModel.controlsSubject.receive(on: DispatchQueue.main).sink { [weak self] items in
            self?.currentControls = items
            self?.subview.tableView.reloadData()
        }.store(in: &disposables)
        viewModel.currentlyWorkingSubject.receive(on: DispatchQueue.main).sink { [weak self] isWorking in
            self?.subview.setProgressIndicator(isOn: isWorking)
        }.store(in: &disposables)
        
        Publishers.CombineLatest(
            viewModel.selectedCookModeSubject,
            viewModel.selectedWoodfireSubject
        ).receive(on: DispatchQueue.main).sink { [weak self] cookMode, woodfire in
            guard let self = self, let cookMode = cookMode, let woodfire = woodfire else { return }
            self.subview.setStartTitle(cookMode: cookMode, woodfireEnabled: woodfire)
        }.store(in: &disposables)
        Publishers.CombineLatest4(
            viewModel.selectedCookTypeSubject,
            viewModel.thermometer0ValuesSubject,
            viewModel.thermometer1ValuesSubject,
            devicesViewModel.currentStateSubject
        ).receive(on: DispatchQueue.main).sink { [weak self] cookType, thermometer1, thermometer2, grillState in
            guard let self = self, let thermometer1 = thermometer1, let thermometer2 = thermometer2 else { return }
            let enabled = self.viewModel.isValidCook(cookType: cookType, thermometer1: thermometer1, thermometer2: thermometer2)
            let online = self.devicesViewModel.isDeviceOnline(state: grillState)
            self.subview.setSubmitEnabled(online: online, enabled: enabled)
        }.store(in: &disposables)
        
        devicesViewModel.currentGrillSubject.receive(on: DispatchQueue.main).sink { [weak self] grill in
            if let grill = grill {
                let name = grill.getName()
                self?.subview.navBar.setSelectedDeviceName(name: name)
            }
        }.store(in: &disposables)
        devicesViewModel.currentStateSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self, let state = state else { return }
            
            if CookDisplayValues.isCookingState(state: state.state) && self.devicesViewModel.isDeviceConnected(state: state) {
                self.toMonitorControl()
            }
            self.viewModel.setProbePluggedIn(index: 0, pluggedIn: state.probe1.pluggedIn)
            self.viewModel.setProbePluggedIn(index: 1, pluggedIn: state.probe2.pluggedIn)
            
            self.subview.navBar.pillView.wifiOnline = self.devicesViewModel.isDeviceOnWifi(state: state)
            self.subview.navBar.pillView.bluetoothOnline = self.devicesViewModel.isDeviceOnBT(state: state)
        }.store(in: &disposables)
    }
    
    func getItems(section: Int) -> [CookItem?] {
        switch section {
        case 0:
            return [viewModel.selectors[.CookType]]
        case 1:
            return [viewModel.selectors[.CookMode]]
        case 2:
            return currentControls
        default:
            return []
        }
    }

    func expandAppliances() {
        let vc = UINavigationController(rootViewController: SelectAppliancesViewController())
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    func startCooking() {
        showAccessoriesModal { [weak self] in
            self?.viewModel.startCooking { error in
                if let error = error {
                    Logger.Error("PRECOOK START ERROR: \(error)")
                } else {
                    Logger.Debug("PRECOOK START SUCCESS")
                }
            }
        }
    }
    
    func toMonitorControl() {
        navigationController?.pushViewController(MonitorControlViewController(), animated: true)
    }
}


extension PreCookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subview.sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItems(section: section).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CookControlsHeader.VIEW_ID) as? CookControlsHeader
        header?.titleLabel.text = subview.sectionHeaders[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: CookItem? = getItems(section: indexPath.section)[indexPath.row]
        if let item = item {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cell.VIEW_ID + item.identifier, for: indexPath)
            if let cookCell = cell as? CookControlsViewCell {
                cookCell.connectData(data: item)
                cookCell.tableView = tableView // TODO: - allow for resizing
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 1 {
            let item = currentControls[indexPath.row]
            if let navigationController = navigationController {
                item.onNavigate?(navigationController, self)
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
}


extension PreCookViewController: SentCookingChartCommandDelegate {
    func sendCookingChartCommand(cookMode: CookMode, temp: Int, duration: Int, infuse: Bool) {
        viewModel.setChartsCook(cookMode: cookMode, temp: UInt32(temp), duration: UInt32(duration), woodfire: infuse)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(toControllerType: PreCookViewController.self, animated: true)
            if self.devicesViewModel.isDeviceOnline(state: self.devicesViewModel.currentStateSubject.value) {
                self.startCooking()
            }
        }
    }
}

// MARK: Modals
extension PreCookViewController {
    
    func showAccessoriesModal(completion: (() -> Void)? = nil) {
        // Prepare the content
        var addCripserBasket: Bool = false
        var modalImages: [UIImage?] = [ImageAssetLibrary.img_grill_tray.asImage(), ImageAssetLibrary.img_grease_tray.asImage()]
        
        // Grill, Smoker, Bake, and Broil use the Grill Tray and the Grease Tray.
        // Roast, Aircrisp, and Dehydrate use those two along with the crisper basket
        guard let cookMode = viewModel.selectedCookModeSubject.value else { return }
        
        let titleText = CookDisplayValues.getModeDisplayName(cookMode: cookMode)
        switch cookMode {
        case .Roast, .AirCrisp, .Dehydrate:
            addCripserBasket = true
        default:
            break
        }
        
        // Add basket image if applicable
        if addCripserBasket { modalImages.append(ImageAssetLibrary.img_aircrisp_basket.asImage()) }
        // Create description label text based on necessary accessories
        let descriptionText = "For this cook mode, you need to add \(addCripserBasket ? "all accessories" : "the grill plate and the grease tray"). Please confirm your grill is safe to begin heating."
        
        // Create the modal
        let vc = AlertModalViewController(
            title: "\(titleText) Cook Mode",
            description: descriptionText,
            images: modalImages,
            primaryAction: .init(title: "Done", buttonStyle: .primaryButton, alertAction: {
                completion?()
            }),
            preventDismissal: true
        )
        
        // Present from the MenuTabBar
        if let tabController = navigationController?.parent {
            tabController.present(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }
    
    func showReviewRequestModal() {
        showModal(
            title: Localizable("menu_review_title").value,
            description: Localizable("menu_review_info").value,
            primaryIcon: IconAssetLibrary.system_thumbsup.asTemplateSystemImage(),
            secondaryIcon: IconAssetLibrary.system_thumbsdown.asTemplateSystemImage(),
            delegate: modalDelegate,
            height: 280,
            completion: {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, let scene = self.view.window?.windowScene else { return }
                    self.menuViewModel.displayReviewRequest(scene: scene)
                }
            }, cancelCompletion: {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showSleazyBadReviewAvoidanceModal()
                }
            }, dismissCompletion: {})
    }
    
    func showSleazyBadReviewAvoidanceModal() {
        showModal(
            title: Localizable("menu_sleazy_title").value,
            description: "",
            primaryText: Localizable("menu_sleazy_yes").value,
            secondaryText: Localizable("menu_sleazy_no").value,
            delegate: modalDelegate,
            height: 250,
            completion: { @MainActor [weak self] in
                guard let self = self else { return }
                self.tabBarController?.selectedIndex = 2
                (self.tabBarController?.selectedViewController as? UINavigationController)?.pushViewController(SupportViewController(), animated: false)
            })
    }

    private func showModal(title: String,
                           description: String,
                           primaryText: String? = nil,
                           secondaryText: String? = nil,
                           primaryIcon: UIImage? = nil,
                           secondaryIcon: UIImage? = nil,
                           delegate: ModalPresentationControllerDelegate,
                           height: CGFloat = 300,
                           dismissable: Bool = true,
                           completion: (() -> Void)?,
                           cancelCompletion: (() -> Void)? = nil,
                           dismissCompletion: (() -> Void)? = nil) {
        vc = MonitorControlModalViewController()
        if let vc = vc {
            vc.modalTitle = title
            vc.modalDescription = description
            vc.primaryButtonText = primaryText
            vc.secondaryButtonText = secondaryText
            vc.primaryButtonIcon = primaryIcon
            vc.secondaryButtonIcon = secondaryIcon
            vc.successCompletion = completion
            vc.cancelCompletion = cancelCompletion
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = delegate
            delegate.dismissCompletion = dismissCompletion ?? cancelCompletion
            delegate.height = height
            delegate.dismissable = dismissable
            self.present(vc, animated: true)
        }
    }
}
