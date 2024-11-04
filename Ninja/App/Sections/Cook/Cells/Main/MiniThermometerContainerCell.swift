//
//  MiniThermometerContainerCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 2/23/23.
//

import UIKit

class MiniThermometerContainerCell: CookControlsViewCell {
    
    var toggleController: ToggleButtonGroupController = .init()
    
    var currentCalculatedState: CalculatedState?
    var currentCookType: CookType?
    var isConnected: Bool = true
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        if let data = data as? CookCellItem<ExtendedGrillThermometer> {
            data.availableValuesSubject.receive(on: DispatchQueue.main).sink { [weak self] thermometers in
                guard let self = self else { return }
                for (index, thermometer) in thermometers.enumerated() {
                    if self.thermometerButtons.count > index {
                        let toggle = self.thermometerButtons[index]
                        var foodString = CookDisplayValues.getFoodDisplayName(food: thermometer.grillThermometer?.food.protein ?? .NotSet)
                        if foodString.isEmpty {
                            foodString = "#\(thermometer.index + 1)"
                        }
                        let currentTemperature = CookDisplayValues.getTemperatureDisplayString(temp: Int(thermometer.grillThermometer?.currentTemp ?? 0), units: "", isThermometer: true)
                        toggle.isAttached = thermometer.grillThermometer?.pluggedIn ?? false
                        toggle.foodTypeLabel.text = foodString // (thermometer.grillThermometer?.pluggedIn ?? false) ? foodString : "--"
                        toggle.thermometerStatusLabel.text = (thermometer.grillThermometer?.pluggedIn ?? false) && self.isConnected ? currentTemperature : "--"
                        toggle.identifier = thermometer
                        toggle.updateIcon()
                        if thermometer.isSelected {
                            _ = self.toggleController.selectButton(self.thermometerButtons[thermometer.index])
                        }
                    }
                }
            }.store(in: &disposables)
            data.extrasSubject.receive(on: DispatchQueue.main).sink { [weak self] state in
                if let state = state as? GrillState {
                    self?.isConnected = SelectApplianceViewModel.shared.isDeviceConnected(state: state)
                    if state.state != self?.currentCalculatedState || state.cookType != self?.currentCookType {
                        let colors = state.cookType == .Timed ? [UIColor.clear.cgColor] : MonitorControlColors.getColorSet(state: state.state).gradientColors
                        self?.thermometerButtons.forEach({ toggle in
                            toggle.setupGradientBorder(colors: colors)
                        })
                        self?.currentCalculatedState = state.state
                        self?.currentCookType = state.cookType
                    }
                }
            }.store(in: &disposables)

            toggleController.onSelectCallback = { toggleButton in
                let toggleThermometer = toggleButton?.identifier as? ExtendedGrillThermometer
                let thermometers = data.availableValuesSubject.value
                thermometers.forEach { thermometer in
                    thermometer.isSelected = (thermometer.index == toggleThermometer?.index)
                }
                // Send update to summary
                data.availableValuesSubject.send(thermometers)
             }
        }
        
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private var thermometerButtons = [MiniThermometerToggleButton(), MiniThermometerToggleButton()]
    
    override func setupViews() {
        super.setupViews()
        
        self.hideShadow()
        self.backgroundColor = .clear
        shadowContainer.backgroundColor = .clear
        
        toggleController.addButtons(thermometerButtons)
    }
    
    override func refreshStyling() {
        let currentTheme = theme()
        toggleController.buttonList.forEach { toggle in
            if let toggle = toggle as? MiniThermometerToggleButton {
                toggle.setStyle(backgroundColor: currentTheme.cellCookBackground, foregroundColor: currentTheme.primaryForegroundColor, font: LabelStyle.cookCellTitle.properties(currentTheme).font)
            }
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        shadowContainer.addSubview(stackView)
        toggleController.buttonList.forEach { toggle in
            stackView.addArrangedSubview(toggle)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor)
        ])
    }
}
