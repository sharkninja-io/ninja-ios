//
//  MonitorControlView.swift
//  Ninja
//
//  Created by Martin Burch on 2/17/23.
//

import UIKit

class MonitorControlView: BaseXIBView {
    
    @IBOutlet var topBackground: UIView!
    @IBOutlet var navBar: DeviceNavBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cookButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var buttonBackground: UIView!
    @IBOutlet var activityWorkingView: ActivityWorkingView!
    @IBOutlet var toastView: ToastView!
    
    var sectionHeaders: [String?] = [nil, nil, "THERMOMETERS".uppercased(), "GRILL SETTINGS".uppercased()]
    var noThermSectionHeaders: [String?] = [nil, nil, "GRILL SETTINGS".uppercased()]
    var isDone = false
    var timer: Timer? = nil
    var buttonStyle: ButtonStyle {
        get {
            isDone ? .primaryButton : .coloredButton(foregroundColor: ColorThemeManager.shared.theme.white01, backgroundColor: ColorThemeManager.shared.theme.quaternaryWarmAccentColor)
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor.black.cgColor, UIColor.white.cgColor] // TODO: - TESTING
        gradient.locations = [0.1, 0.9]
        return gradient
    }()
    
    lazy var bottomGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor.black.withAlphaComponent(0.0), UIColor.black.cgColor]
        gradient.locations = [0, 0.33]
        return gradient
    }()
    
    override func setupViews() {
        super.setupViews()
        
        navBar.theme = { ColorThemeManager.shared.monitorControlTheme }
        navBar.pillView.errorColor = navBar.theme().primaryErrorForegroundColor
        
        tableView.register(CookControlsHeader.self, forHeaderFooterViewReuseIdentifier: CookControlsHeader.VIEW_ID)
        tableView.register(CookTypeViewCell.self, forCellReuseIdentifier: CookTypeViewCell.VIEW_ID)
        tableView.register(WoodfireViewCell.self, forCellReuseIdentifier: WoodfireViewCell.VIEW_ID)
        tableView.register(TemperatureViewCell.self, forCellReuseIdentifier: TemperatureViewCell.VIEW_ID)
        tableView.register(TimeTemperatureViewCell.self, forCellReuseIdentifier: TimeTemperatureViewCell.VIEW_ID)
        tableView.register(ThermometerSummaryViewCell.self, forCellReuseIdentifier: ThermometerSummaryViewCell.VIEW_ID)
        tableView.register(MiniThermometerContainerCell.self, forCellReuseIdentifier: MiniThermometerContainerCell.VIEW_ID)
        tableView.register(GrillModeViewCell.self, forCellReuseIdentifier: GrillModeViewCell.VIEW_ID)
        tableView.register(CookProgressCell.self, forCellReuseIdentifier: CookProgressCell.VIEW_ID)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        cookButton.setTitle("STOP COOKING".uppercased(), for: .normal)
        
        navBar.showBackButton = false
        
        activityWorkingView.overlayColor = 0x000000.hexToUIColor(alpha: 0.5)
        setProgressIndicator(isOn: false)
        
        toastView.closeCompletion = hideToast
        toastView.alpha = 0.0
        toastView.layer.zPosition = -100
        toastView.isHidden = true

        gradientLayer.frame = self.bounds
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        buttonBackground.backgroundColor = .clear
        bottomGradientLayer.frame = buttonBackground.bounds
        buttonBackground.layer.insertSublayer(bottomGradientLayer, at: 0)
        
        setBackgroundGradient(endColor: MonitorControlColors.invalid.background, duration: 1)
    }
    
    func setViewAsDone(isDone: Bool) {
        self.isDone = isDone
        if isDone {
            cookButton.setTitle("BACK TO DASHBOARD".uppercased(), for: .normal)
        } else {
            cookButton.setTitle("STOP COOKING".uppercased(), for: .normal)
        }
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
    
    func showToast(icon: UIImage, title: String, message: String, colors: [CGColor], timeout: TimeInterval = 10) {
        timer?.invalidate()
        toastView.setup(icon: icon, title: title, message: message, colors: colors)
        toastView.layer.zPosition = 100
        toastView.isHidden = false
        setNeedsLayout()
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.toastView.alpha = 1.0
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] timer in
            timer.invalidate()
            DispatchQueue.main.async {
                self?.hideToast(duration: 1)
            }
        }
    }
    
    func hideToast() {
        hideToast(duration: 0.5)
    }
    
    func hideToast(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.toastView.alpha = 0.0
        }, completion: { [weak self] done in
            self?.toastView.layer.zPosition = -100
            self?.toastView.isHidden = true
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomGradientLayer.frame = buttonBackground.bounds
    }
    
    override func refreshStyling() {
        topBackground.backgroundColor = ColorThemeManager.shared.monitorControlTheme.primaryBackgroundColor
        
        tableView.backgroundColor = .clear
        bottomGradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
        cookButton.setStyle(buttonStyle, theme: ColorThemeManager.shared.monitorControlTheme)
    }
    
    func setBackgroundGradient(startColor: UIColor = .black, endColor: UIColor, duration: CGFloat = 1) {
        gradientLayer.animateColorChange(newColors: [startColor.cgColor, endColor.cgColor], duration: duration)
    }
}
