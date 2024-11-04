//
//  PickerViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 2/6/23.
//

import UIKit
import Combine

class DonenessPickerViewCell: CookControlsViewCell {
    
    var pickerManager: GenericPickerManager<DonenessPickerRow, FoodPreset>?
    var currentUnits: String?
    var selectedRow: Int?
    var selectorItem: CookCellItem<FoodPreset>?

    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        if let selectorItem = data as? CookCellItem<FoodPreset> {
            self.selectorItem = selectorItem
            selectorItem.availableValuesSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] values in
                guard let self = self else { return }
                self.pickerManager?.values = values
                self.picker.reloadAllComponents()
                if selectorItem.currentValueSubject.value == nil {
                    selectorItem.currentValueSubject.send(values.first)
                } else if values.count > 0, self.selectedRow != nil {
                    let index = (self.selectedRow ?? 0) < values.count ? (self.selectedRow ?? 0) : 0
                    selectorItem.currentValueSubject.send(values[index])
                }
            }.store(in: &disposables)
            selectorItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] current in
                if let current = current {
                    self?.selectRow(index: Int(current.presetIndex))
                } else if let firstValue = selectorItem.availableValuesSubject.value.first {
                    selectorItem.currentValueSubject.send(firstValue)
                }
            }.store(in: &disposables)
            selectorItem.unitsSubject.receive(on: DispatchQueue.main).sink { [weak self] units in
                if let units = units {
                    self?.currentUnits = units
                    self?.picker.reloadAllComponents()
                }
            }.store(in: &disposables)
        }
    }
    
    func saveValue() {
        if let value = selectorItem?.availableValuesSubject.value[picker.selectedRow(inComponent: 0)] {
            selectorItem?.currentValueSubject.send(value)
        }
    }
    
    var shadowRadius: CGFloat = 3
    var borderWidth: CGFloat = 1

    @UsesAutoLayout var shadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.shadowColor = ColorThemeManager.shared.theme.primaryForegroundColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorThemeManager.shared.theme.primaryBackgroundColor.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    @UsesAutoLayout var titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "DONENESS POINT".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    @UsesAutoLayout var verticalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorThemeManager.shared.theme.grey03
        return view
    }()

    @UsesAutoLayout var titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "INTERNAL TEMP".uppercased()
        label.textAlignment = .center
        return label
    }()

    @UsesAutoLayout var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        return stack
    }()

    @UsesAutoLayout var titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorThemeManager.shared.theme.grey03
        return view
    }()

    @UsesAutoLayout var picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    @UsesAutoLayout var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 12
        return stack
    }()
    
    deinit {
        disposables.removeAll()
    }
    
    func selectRow(index: Int) {
        guard let count = pickerManager?.values.count, count > 0 else { return }
        
        let safeIndex = (index < count) ? index : 0
        self.selectedRow = safeIndex
        picker.selectRow(safeIndex, inComponent: 0, animated: true)
        self.picker.reloadAllComponents()
    }
    
    func hideTitles(hide: Bool) {
        titleStack.isHidden = hide
        titleSeparator.isHidden = hide
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.hideShadow()
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.selectionStyle = .none
        self.accessoryType = .none
        
        pickerManager = GenericPickerManager<DonenessPickerRow, FoodPreset>(
            values: [],
            setData: { [weak self] pickerView, data, row in
                guard let self = self else { return }
                pickerView.donenessValue = data.tempDescription
                pickerView.tempValue = CookDisplayValues.getTemperatureDisplayString(temp: Int(data.temp), units: "", isThermometer: true)
                pickerView.isSelected = row == self.selectedRow
                pickerView.theme = self.theme
            }) { [weak self] pickerView, data, row in
                self?.selectedRow = row
                pickerView.isSelected = true
                self?.saveValue()
                self?.picker.reloadAllComponents()
            }

        picker.delegate = pickerManager
        picker.dataSource = pickerManager
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleStack.addArrangedSubview(titleLabel1)
        titleStack.addArrangedSubview(titleLabel2)
        containerStack.addArrangedSubview(titleStack)
        containerStack.addArrangedSubview(titleSeparator)
        containerStack.addArrangedSubview(picker)
        
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(containerStack)
        self.contentView.addSubview(verticalSeparator)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            containerStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: shadowRadius + 16),
            containerStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -shadowRadius - 8),
            containerStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: borderWidth),
            containerStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -borderWidth),
            titleSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            containerStack.heightAnchor.constraint(equalToConstant: 200),

            verticalSeparator.widthAnchor.constraint(equalToConstant: 1),
            verticalSeparator.topAnchor.constraint(equalTo: titleStack.topAnchor),
            verticalSeparator.bottomAnchor.constraint(equalTo: titleStack.bottomAnchor),
            verticalSeparator.centerXAnchor.constraint(equalTo: titleStack.centerXAnchor),
        ])
    }
    
    override func refreshStyling() {
        self.backgroundColor = .clear
        shadowContainer.backgroundColor = theme().tertiaryCookBackground
        shadowView.layer.shadowColor = theme().shadowCookColor.cgColor
        shadowView.layer.borderColor = theme().primaryBackgroundColor.cgColor

        titleSeparator.backgroundColor = theme().secondaryCookBackground
        verticalSeparator.backgroundColor = theme().secondaryCookBackground
        titleLabel1.setStyle(.donenessPickerTitleLabel, theme: theme())
        titleLabel2.setStyle(.donenessPickerTitleLabel, theme: theme())
    }
}
