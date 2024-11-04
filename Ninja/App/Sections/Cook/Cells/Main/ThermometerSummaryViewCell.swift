//
//  FullThermometerViewCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 2/21/23.
//

import UIKit

class ThermometerSummaryViewCell: CookControlsViewCell {
    
    var showTemperature: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        if let data = data as? CookCellItem<ExtendedGrillThermometer> {
            data.availableValuesSubject.receive(on: DispatchQueue.main).sink { [weak self] thermometers in
                guard let self = self else { return }
                let thermometer = thermometers.first(where: { $0.isSelected })
                if let thermometer = thermometer, thermometer.grillThermometer?.active == true {
                    self.donenessLabel.text = CookDisplayValues.getDonenessDisplayString(doneness: thermometer.grillThermometer?.food.doneness, food: thermometer.grillThermometer?.food.protein)
                    self.temperatureLabel.text = CookDisplayValues.getTemperatureDisplayString(temp: Int(thermometer.grillThermometer?.desiredTemp ?? 0), units: "", isThermometer: true)
                    self.showTemperature = CookDisplayValues.isShowTargetTempState(state: thermometer.grillThermometer?.state)
                } else {
                    self.donenessLabel.text = "--"
                    self.temperatureLabel.text = "--"
                }
            }.store(in: &disposables)
        }
    }
    
    @UsesAutoLayout var donenessCircle: UIImageView = {
        let image = UIImageView()
        image.image = IconAssetLibrary.ico_doneness_icon.asImage()?.tint(color: ColorThemeManager.shared.theme.tertiaryWarmAccentColor)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    @UsesAutoLayout var donenessLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        return label
    }()
    
    @UsesAutoLayout var donenessInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Doneness".uppercased()
        return label
    }()

    lazy var donenessHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    lazy var donenessVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    @UsesAutoLayout var divider = UIView()
    
    @UsesAutoLayout var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        return label
    }()
    
    @UsesAutoLayout var temperatureInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Target temp".uppercased()
        return label
    }()
    
    lazy var temperatureVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
        
    @UsesAutoLayout var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.image =  IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: .white)
        return imageView
    }()

    lazy var mainHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func setupViews() {
        super.setupViews()
        
        donenessCircle.image = IconAssetLibrary.ico_doneness_icon.asTemplateImage()?.tint(color: theme().tertiaryWarmAccentColor)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        donenessLabel.setStyle(.cookCellTitleBold, theme: theme())
        donenessInfoLabel.setStyle(.cookCellInfo, theme: theme())
        if showTemperature {
            divider.backgroundColor = theme().grey02
            temperatureLabel.setStyle(.cookCellTitleBold, theme: theme())
            temperatureInfoLabel.setStyle(.cookCellInfo, theme: theme())
        } else {
            divider.backgroundColor = .clear
            temperatureLabel.textColor = .clear
            temperatureInfoLabel.textColor = .clear
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        donenessHStack.addArrangedSubview(donenessCircle)
        donenessHStack.addArrangedSubview(donenessLabel)
        donenessVStack.addArrangedSubview(donenessHStack)
        donenessVStack.addArrangedSubview(donenessInfoLabel)
        temperatureVStack.addArrangedSubview(temperatureLabel)
        temperatureVStack.addArrangedSubview(temperatureInfoLabel)

        mainHStack.addArrangedSubview(donenessVStack)
        mainHStack.addArrangedSubview(divider)
        mainHStack.addArrangedSubview(temperatureVStack)
        mainHStack.addArrangedSubview(arrowIcon)

        shadowContainer.addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 32),
            
            donenessCircle.widthAnchor.constraint(equalToConstant: 12),
            donenessCircle.heightAnchor.constraint(equalToConstant: 12),
            
            mainHStack.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor, constant: 16),
            mainHStack.topAnchor.constraint(equalTo: shadowContainer.topAnchor, constant: 16),
            mainHStack.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: -16),
            mainHStack.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor, constant: -16),
        ])
    }
}
