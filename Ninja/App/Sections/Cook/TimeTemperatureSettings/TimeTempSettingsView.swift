//
//  TimeTempSettingsView.swift
//  Ninja
//
//  Created by Martin Burch on 2/3/23.
//

import UIKit

class TimeTempSettingsView: BaseXIBView {

    @IBOutlet var topBackground: UIView!
    @IBOutlet var navBar: DeviceNavBar! // TODO: //
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    
    var sectionHeaders: [String] = ["COOK MODE".uppercased(), "TIME TO COOK".uppercased(), "GRILL TEMPERATURE".uppercased()]
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme } {
        didSet {
            navBar.theme = theme
        }
    }

    override func setupViews() {
        super.setupViews()
        
        navBar.showDeviceButton = false
        navBar.theme = theme

        tableView.register(CookControlsHeader.self, forHeaderFooterViewReuseIdentifier: CookControlsHeader.VIEW_ID)
        tableView.register(TimePickerViewCell.self, forCellReuseIdentifier: TimePickerViewCell.VIEW_ID)
        tableView.register(TemperaturePickerViewCell.self, forCellReuseIdentifier: TemperaturePickerViewCell.VIEW_ID)
        tableView.register(ModeSelectionViewCell.self, forCellReuseIdentifier: ModeSelectionViewCell.VIEW_ID)
        tableView.register(CookingChartsCTACell.self, forCellReuseIdentifier: CookingChartsCTACell.VIEW_ID)

        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        saveButton.setTitle("SAVE CHANGES".uppercased(), for: .normal)
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
