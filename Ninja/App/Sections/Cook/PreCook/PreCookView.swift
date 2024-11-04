//
//  CookView.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit

class PreCookView: BaseXIBView {
    
    @IBOutlet var topBackground: UIView!
    @IBOutlet var navBar: DeviceNavBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cookButton: UIButton!
    @IBOutlet var activityWorkingView: ActivityWorkingView!
    @IBOutlet var buttonContainer: UIView!

    var sectionHeaders = ["MONITOR METHOD".uppercased(), "COOK MODE".uppercased(), "COOK SETTINGS".uppercased()]
    enum StartTitles {
        case ignition
        case preheat
        case cook
        case offline
        
        var value: String {
            switch self {
            case .ignition:
                return "Start Ignition".uppercased()
            case .preheat:
                return "Start Preheat".uppercased()
            case .cook:
                return "Start Cooking".uppercased()
            case .offline:
                return "Grill Offline".uppercased()
            }
        }
    }
    
    var startTitle: String = "Start Preheat".uppercased()
    var online: Bool = false
    
    lazy var bottomGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, ColorThemeManager.shared.theme.primaryBackgroundColor.cgColor]
        gradient.locations = [0, 0.33]
        return gradient
    }()
    
    override func setupViews() {
        super.setupViews()
        
        activityWorkingView.overlayColor = 0x000000.hexToUIColor(alpha: 0.5)
        setProgressIndicator(isOn: false)

        tableView.register(CookControlsHeader.self, forHeaderFooterViewReuseIdentifier: CookControlsHeader.VIEW_ID)
        tableView.register(CookTypeViewCell.self, forCellReuseIdentifier: CookTypeViewCell.VIEW_ID)
        tableView.register(ModeSelectionViewCell.self, forCellReuseIdentifier: ModeSelectionViewCell.VIEW_ID)
        tableView.register(WoodfireViewCell.self, forCellReuseIdentifier: WoodfireViewCell.VIEW_ID)
        tableView.register(TemperatureViewCell.self, forCellReuseIdentifier: TemperatureViewCell.VIEW_ID)
        tableView.register(ThermometerViewCell.self, forCellReuseIdentifier: "\(ThermometerViewCell.VIEW_ID)1")
        tableView.register(ThermometerViewCell.self, forCellReuseIdentifier: "\(ThermometerViewCell.VIEW_ID)2")
        tableView.register(TimeTemperatureViewCell.self, forCellReuseIdentifier: TimeTemperatureViewCell.VIEW_ID)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        setSubmitEnabled(online: online, enabled: false)
        
        buttonContainer.backgroundColor = .clear
        bottomGradientLayer.frame = buttonContainer.bounds
        buttonContainer.layer.insertSublayer(bottomGradientLayer, at: 0)

        navBar.showBackButton = false
    }
    
    func setProgressIndicator(isOn: Bool) {
        if isOn {
            activityWorkingView.start()
        }
        tableView.isUserInteractionEnabled = !isOn
        cookButton.isUserInteractionEnabled = !isOn
        activityWorkingView.isHidden = !isOn
        activityWorkingView.layer.zPosition = isOn ? 10 : -10
        if !isOn {
            activityWorkingView.stop()
        }
    }
    
    func setSubmitEnabled(online: Bool, enabled: Bool) {
        self.online = online
        cookButton.isEnabled = online && enabled
        cookButton.setTitle(online ? self.startTitle : StartTitles.offline.value, for: .normal)
    }
    
    func setStartTitle(cookMode: CookMode, woodfireEnabled: Bool) {
        if woodfireEnabled {
            self.startTitle = StartTitles.ignition.value
        } else {
            self.startTitle = CookDisplayValues.hasNoPreheat(cookMode: cookMode) ? StartTitles.cook.value : StartTitles.preheat.value
        }
        cookButton.setTitle(online ? self.startTitle : StartTitles.offline.value, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomGradientLayer.frame = buttonContainer.bounds
    }

    override func refreshStyling() {
        self.subviews.forEach { view in
            view.backgroundColor = ColorThemeManager.shared.theme.grey04
        }

        topBackground.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        tableView.backgroundColor = .clear
        bottomGradientLayer.colors = [ColorThemeManager.shared.theme.primaryBackgroundColor.withAlphaComponent(0.0).cgColor, ColorThemeManager.shared.theme.primaryBackgroundColor.cgColor]
//        cookButton.setStyle(.coloredButton(foregroundColor: ColorThemeManager.shared.theme.primaryBackgroundColor, backgroundColor: ColorThemeManager.shared.theme.secondaryForegroundColor))
        cookButton.setStyle(.primaryButton)
    }
    
}
