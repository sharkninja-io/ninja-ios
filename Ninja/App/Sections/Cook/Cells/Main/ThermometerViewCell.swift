//
//  ThermometerCookViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit

class ThermometerViewCell: CookControlsViewCell {
    
    var cellText: String?
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        disposables.removeAll()
        
        if let dataItem = data as? CookCellItem<PrecookThermometer> {
            cellText = dataItem.title
            title.text = dataItem.title
            
            dataItem.enabledSubject?.receive(on: DispatchQueue.main).sink { [weak self] isOn in
                guard self?.toggle.isOn != isOn else { return }
                self?.toggle.setOn(isOn, animated: true)
                self?.toggleExpanded(isExpanded: isOn)
            }.store(in: &disposables)
            dataItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] thermometer in
                guard let self = self else { return }
                self.setTemperature(preset: thermometer?.foodPreset, temperature: thermometer?.temperature, food: thermometer?.food)
                self.setTitle(cellText: self.cellText, food: thermometer?.food)
                self.setConnected(isConnected: thermometer?.pluggedIn ?? false)
            }.store(in: &disposables)
            
            toggle.onEvent { [weak self] control in
                guard let self = self else { return }
                self.setTitle(cellText: self.cellText, food: dataItem.currentValueSubject.value?.food)
                dataItem.enabledSubject?.send(self.toggle.isOn)
            }
        }
    }
    
    func setTitle(cellText: String?, food: Food?) {
        if !self.toggle.isOn {
            self.title.text = cellText
        } else if let food = food, food != .Manual, food != .NotSet {
            self.title.text = CookDisplayValues.getFoodDisplayName(food: food)
        } else {
            self.title.text = cellText
        }
    }
    
    func setTemperature(preset: FoodPreset?, temperature: UInt32?, food: Food?) {
        if let food = food, food != .Manual, food != .NotSet {
            self.temperatureLabel.text = preset?.tempDescription
        } else if let temp = temperature {
            self.temperatureLabel.text = CookDisplayValues.getTemperatureDisplayString(temp: Int(temp), units: "", isThermometer: true)
        } else {
            self.temperatureLabel.text = "---°F"
        }
    }
    
    @UsesAutoLayout var icon: UIImageView = {
        let image = UIImageView()
        image.image = IconAssetLibrary.ico_probe_unplugged.asTemplateImage()
        image.contentMode = .scaleAspectFit
        return image
    }()
    @UsesAutoLayout var title: UILabel = {
        let label = UILabel()
        return label
    }()
    @UsesAutoLayout var toggle: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()
    @UsesAutoLayout var titleContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    @UsesAutoLayout var detailDivider: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    @UsesAutoLayout var temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    @UsesAutoLayout var tempDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    @UsesAutoLayout var arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = IconAssetLibrary.ico_arrow_right.asTemplateImage()
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return image
    }()
    @UsesAutoLayout var detailsContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    var detailsBottomConstraint: NSLayoutConstraint?
    var detailsBottomConstraint2: NSLayoutConstraint?
    var detailsTopConstraint: NSLayoutConstraint?
    var contractedConstraint: NSLayoutConstraint?
    
    func setConnected(isConnected: Bool) {
        icon.image = isConnected ? IconAssetLibrary.ico_probe_connected.asTemplateImage() : IconAssetLibrary.ico_probe_unplugged.asTemplateImage()
        icon.tintColor = isConnected ? theme().primaryAccentColor : theme().grey02
    }
    
    override func setupViews() {
        super.setupViews()
        
        temperatureLabel.text = "---°F"
        tempDescriptionLabel.text = "Target Temp".uppercased()
        
        toggle.onEvent() { [weak self] _ in
            guard let self = self else { return }
            self.toggleExpanded(isExpanded: self.toggle.isOn)
        }
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        title.setStyle(.cookCellTitle, theme: theme())
        
        detailDivider.backgroundColor = theme().grey03
        
        temperatureLabel.setStyle(.cookCellSimpleTitle, theme: theme())
        tempDescriptionLabel.setStyle(.cookCellDetailItem, theme: theme())
        arrowImage.tintColor = theme().grey02
     }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        shadowContainer.addSubview(titleContainer)
        shadowContainer.addSubview(detailsContainer)
        
        titleContainer.addSubview(icon)
        titleContainer.addSubview(title)
        titleContainer.addSubview(toggle)
        
        detailsContainer.addSubview(detailDivider)
        detailsContainer.addSubview(temperatureLabel)
        detailsContainer.addSubview(tempDescriptionLabel)
        detailsContainer.addSubview(arrowImage)
        
        contractedConstraint = titleContainer.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor)
        contractedConstraint?.isActive = true
        detailsTopConstraint = detailsContainer.topAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        detailsTopConstraint?.isActive = false
        detailsBottomConstraint = detailsContainer.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor)
        detailsBottomConstraint?.isActive = false
        detailsBottomConstraint2 = tempDescriptionLabel.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -16)
        detailsBottomConstraint2?.isActive = false

        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: detailsContainer.topAnchor),
            titleContainer.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor),
            
            detailsContainer.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
            detailsContainer.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor),

            icon.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 16),
            icon.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -16),
            icon.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            icon.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant: -8),
            title.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -16),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -12),
            toggle.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 16),
            toggle.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -16),
            toggle.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 12),
            toggle.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -24),
            
            detailDivider.topAnchor.constraint(equalTo: detailsContainer.topAnchor),
            detailDivider.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            detailDivider.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -16),
            detailDivider.heightAnchor.constraint(equalToConstant: 1),
            detailDivider.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -8),

            temperatureLabel.topAnchor.constraint(equalTo: detailDivider.bottomAnchor, constant: 8),
            temperatureLabel.bottomAnchor.constraint(equalTo: tempDescriptionLabel.topAnchor, constant: -4),
            temperatureLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            temperatureLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -8),

            tempDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            tempDescriptionLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            tempDescriptionLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -8),
            
            arrowImage.centerYAnchor.constraint(equalTo: detailsContainer.centerYAnchor),
            arrowImage.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 8),
            arrowImage.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -24),
        ])
        
    }
    
    func toggleExpanded(isExpanded: Bool) {
        self.tableView?.beginUpdates()
        if isExpanded {
            contractedConstraint?.isActive = false
            detailsTopConstraint?.isActive = true
            detailsBottomConstraint?.isActive = true
            detailsBottomConstraint2?.isActive = true
            detailsContainer.isHidden = false
        } else {
            detailsContainer.isHidden = true
            detailsTopConstraint?.isActive = false
            detailsBottomConstraint?.isActive = false
            detailsBottomConstraint2?.isActive = false
            contractedConstraint?.isActive = true
        }
        self.tableView?.endUpdates()
    }
    
}
