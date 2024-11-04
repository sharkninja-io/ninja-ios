//
//  ThermometerSettingsView.swift
//  Ninja
//
//  Created by Martin Burch on 2/3/23.
//

import UIKit

class ThermometerSettingsView: BaseXIBView {
    
    @IBOutlet var topBackground: UIView!
    @IBOutlet var navBar: DeviceNavBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    
    var sectionHeaders: [String?] = ["FOOD SELECTOR", "COOKING POINT", nil]
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme } {
        didSet {
            navBar.theme = theme
        }
    }
    
    var buttonTitle: String = "Thermometer" {
        didSet {
            navBar.backButton.setTitle(buttonTitle, for: .normal)
        }
    }

    override func setupViews() {
        super.setupViews()
        
        navBar.showDeviceButton = false
        navBar.theme = theme

        tableView.register(CookControlsHeader.self, forHeaderFooterViewReuseIdentifier: CookControlsHeader.VIEW_ID)
        tableView.register(ProteinSelectionViewCell.self, forCellReuseIdentifier: ProteinSelectionViewCell.VIEW_ID)
        tableView.register(DonenessPickerViewCell.self, forCellReuseIdentifier: DonenessPickerViewCell.VIEW_ID)
        tableView.register(TemperaturePickerViewCell.self, forCellReuseIdentifier: TemperaturePickerViewCell.VIEW_ID)
        tableView.register(HowToPlaceThermometerCell.self, forCellReuseIdentifier: HowToPlaceThermometerCell.VIEW_ID)
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        setProbeConnected(true)
    }
    
    func setProbeConnected(_ isConnected: Bool) {
        saveButton.isEnabled = isConnected
        saveButton.setTitle(isConnected ? "SAVE CHANGES".uppercased() : "PLUG IN \(buttonTitle.uppercased())".uppercased() , for: .normal)
    }
    
    override func refreshStyling() {
        self.subviews.forEach { view in
            view.backgroundColor = theme().secondaryCookBackground
        }
        
        topBackground.backgroundColor = theme().primaryCookBackground
        tableView.backgroundColor = .clear
        saveButton.setStyle(.primaryButton, theme: theme())
    }
}
