//
//  CookTimeAndTemperatureCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/12/23.
//

import UIKit

class TimeTemperatureViewCell: CookControlsViewCell {
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)

        disposables.removeAll()
        
        // PRECOOK
        if let dataItem = data as? CookCellItem<(String, String)> {
            dataItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] timeTemp in
                if let timeTemp = timeTemp {
                    self?.timeLabel.text = timeTemp.0
                    self?.temperatureLabel.text = timeTemp.1
                    self?.layoutIfNeeded()
                }
            }.store(in: &disposables)
        }
        // MONITOR / CONTROL
        if let dataItem = data as? CookCellItem<GrillState> {
            self.timeIcon.image = IconAssetLibrary.ico_timer.asImage()?.tint(color: .white) // TODO: -
            dataItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] grillState in
                guard let self = self else { return }
                if let grillState = grillState {
                    let temperature = grillState.oven.desiredTemp
                    let temperatureUnits = dataItem.unitsSubject.value ?? ""
                    self.timeLabel.text = CookDisplayValues.getModeTimeDisplayString(cookMode: grillState.cookMode, time: Int(grillState.oven.timeSet))
                    self.temperatureLabel.text = CookDisplayValues.getTemperatureDisplayString(temp: Int(temperature), units: temperatureUnits, mode: grillState.cookMode)
                    self.temperatureInfoLabel.text = "\(CookDisplayValues.getModeDisplayName(cookMode: grillState.cookMode)) TEMP".uppercased()
                    self.temperatureIcon.image = CookDisplayValues.getModeImage(cookMode: grillState.cookMode)?.tint(color: self.theme().primaryTextColor) // TODO: -
                    self.layoutIfNeeded()
                }
            }.store(in: &disposables)
        }
    }
    
    // Timer Objects
    @UsesAutoLayout var timeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconAssetLibrary.ico_timer.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    @UsesAutoLayout var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    @UsesAutoLayout var timeInfoLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    @UsesAutoLayout var timeVStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 1
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    @UsesAutoLayout var timeContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 4
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    // Temperature objects
    @UsesAutoLayout var temperatureIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconAssetLibrary.ico_thermometer.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @UsesAutoLayout var temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    @UsesAutoLayout var temperatureInfoLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    @UsesAutoLayout var tempVStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 1
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    @UsesAutoLayout var tempContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 4
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    @UsesAutoLayout var divider: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    @UsesAutoLayout var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: ColorThemeManager.shared.theme.grey02)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    @UsesAutoLayout var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()
    
    override func setupViews() {
        super.setupViews()
        
        timeLabel.text = "00:00"
        timeInfoLabel.text = "Cook Time".uppercased()
        temperatureLabel.text = "---°F"
        temperatureInfoLabel.text = "Temp".uppercased()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        divider.backgroundColor = theme().grey03
        
        timeLabel.setStyle(.cookCellTemp, theme: theme())
        temperatureLabel.setStyle(.cookCellTemp, theme: theme())
        
        timeInfoLabel.setStyle(.cookCellInfo, theme: theme())
        temperatureInfoLabel.setStyle(.cookCellInfo, theme: theme())
        
        timeIcon.tintColor = theme().secondaryTextColor
        temperatureIcon.tintColor = theme().secondaryTextColor
        arrowIcon.image = IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: theme().secondaryTextColor)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        timeVStack.addArrangedSubview(timeLabel)
        timeVStack.addArrangedSubview(timeInfoLabel)
        timeContainer.addArrangedSubview(timeIcon)
        timeContainer.addArrangedSubview(timeVStack)
        
        tempVStack.addArrangedSubview(temperatureLabel)
        tempVStack.addArrangedSubview(temperatureInfoLabel)
        tempContainer.addArrangedSubview(temperatureIcon)
        tempContainer.addArrangedSubview(tempVStack)
        
        stackView.addArrangedSubview(timeContainer)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(tempContainer)
        shadowContainer.addSubview(stackView)
        shadowContainer.addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 32),

            stackView.topAnchor.constraint(equalTo: shadowContainer.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -8),

//            arrowIcon.topAnchor.constraint(equalTo: shadowContainer.topAnchor, constant: 16),
//            arrowIcon.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: -16),
            arrowIcon.widthAnchor.constraint(equalToConstant: 24),
            arrowIcon.heightAnchor.constraint(equalToConstant: 24),
            arrowIcon.centerYAnchor.constraint(equalTo: shadowContainer.centerYAnchor),
            arrowIcon.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
            arrowIcon.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor, constant: -16)
        ])
    }
}
