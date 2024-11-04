//
//  TemperatureViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit

class TemperatureViewCell: CookControlsViewCell {
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        disposables.removeAll()
        
        // PRECOOK
        if let dataItem = data as? CookCellItem<(String, String)> {
            dataItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] timeTemp in
                if let timeTemp = timeTemp {
                    self?.temperatureLabel.text = timeTemp.1
                }
            }.store(in: &disposables)
        }
        // MONITOR / CONTROL
        if let dataItem = data as? CookCellItem<GrillState> {
            dataItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] grillState in
                guard let self = self else { return }
                if let grillState = grillState {
                    let temperatureUnits = dataItem.unitsSubject.value ?? ""
                    self.temperatureLabel.text = CookDisplayValues.getTemperatureDisplayString(temp: Int(grillState.oven.desiredTemp), units: temperatureUnits, mode: grillState.cookMode)
                    self.infoLabel.text = "\(CookDisplayValues.getModeDisplayName(cookMode: grillState.cookMode)) TEMP".uppercased()
                    self.temperatureIcon.image = CookDisplayValues.getModeImage(cookMode: grillState.cookMode)?.tint(color: self.theme().primaryTextColor) // TODO: -
                    self.layoutIfNeeded()
                }
            }.store(in: &disposables)
        }
    }
    
    var temperatureIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_thermometer.asImage()?.tint(color: ColorThemeManager.shared.theme.grey01)
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return image
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var arrowIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: ColorThemeManager.shared.theme.grey01)
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return image
    }()
    
    override func setupViews() {
        super.setupViews()

        temperatureLabel.text = "---°F" // Initialize height
        infoLabel.text = "GRILL TEMP".uppercased()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        temperatureLabel.setStyle(.cookCellTemp, theme: theme())
        infoLabel.setStyle(.cookCellInfo, theme: theme())
        arrowIcon.image = IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: theme().secondaryTextColor)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        shadowContainer.addSubview(temperatureIcon)
        shadowContainer.addSubview(temperatureLabel)
        shadowContainer.addSubview(infoLabel)
        shadowContainer.addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            temperatureIcon.centerYAnchor.constraint(equalTo: self.shadowContainer.centerYAnchor),
            temperatureIcon.leadingAnchor.constraint(equalTo: self.shadowContainer.leadingAnchor, constant: 16),
            temperatureIcon.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -12),
            
            temperatureLabel.topAnchor.constraint(equalTo: self.shadowContainer.topAnchor, constant: 12),
            temperatureLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: 0),
            temperatureLabel.leadingAnchor.constraint(equalTo: temperatureIcon.trailingAnchor, constant: 12),
            temperatureLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -12),

            infoLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 0),
            infoLabel.bottomAnchor.constraint(equalTo: self.shadowContainer.bottomAnchor, constant: -12),
            infoLabel.leadingAnchor.constraint(equalTo: temperatureIcon.trailingAnchor, constant: 12),
            infoLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -12),
            
            arrowIcon.centerYAnchor.constraint(equalTo: self.shadowContainer.centerYAnchor),
            arrowIcon.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor, constant: 12),
            arrowIcon.trailingAnchor.constraint(equalTo: self.shadowContainer.trailingAnchor, constant: -24),
        ])
    }

}
