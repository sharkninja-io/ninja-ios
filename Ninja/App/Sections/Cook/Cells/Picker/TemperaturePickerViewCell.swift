//
//  PickerViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 2/6/23.
//

import UIKit
import Combine

class TemperaturePickerViewCell: CookControlsViewCell {
    
    var tempPickerManager: GenericPickerManager<TempPickerRow, UInt32>?
    var currentUnits: String = ""
    var selectedRow: Int?
    var selectorItem: CookCellItem<UInt32>?
    var isThermometer: Bool = false
    var cookMode: CookMode = .Unknown

    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        if let selectorItem = data as? CookCellItem<UInt32> {
            self.selectorItem = selectorItem
            self.isThermometer = (selectorItem.identifier == "isThermometer")
            
            selectorItem.availableValuesSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] values in
                guard let self = self else { return }
                self.tempPickerManager?.values = values
                self.picker.reloadAllComponents()
                if selectorItem.currentValueSubject.value == nil {
                    selectorItem.currentValueSubject.send(values.first)
                } else if values.count > 0, self.selectedRow != nil {
                    let index = (self.selectedRow ?? 0) < values.count ? (self.selectedRow ?? 0) : 0
                    selectorItem.currentValueSubject.send(values[index])
                }
            }.store(in: &disposables)
            selectorItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] current in
                if let current = current, let index = self?.tempPickerManager?.values.firstIndex(of: current) {
                    self?.selectRow(index: index)
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
            selectorItem.extrasSubject.receive(on: DispatchQueue.main).sink { [weak self] cookMode in
                guard let self = self else { return }
                if let cookMode = cookMode as? CookMode {
                    self.cookMode = cookMode
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
    
    @UsesAutoLayout var picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    deinit {
        disposables.removeAll()
    }
    
    func selectRow(index: Int) {
        guard let count = tempPickerManager?.values.count, count > 0 else { return }
        
        let safeIndex = (index < count) ? index : 0
        self.selectedRow = safeIndex
        picker.selectRow(safeIndex, inComponent: 0, animated: true)
        self.picker.reloadAllComponents()
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.hideShadow()
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.selectionStyle = .none
        self.accessoryType = .none
        
        tempPickerManager = GenericPickerManager<TempPickerRow, UInt32>(
            values: [],
            setData: { [weak self] pickerView, data, row in
                guard let self = self else { return }
                pickerView.tempValue = CookDisplayValues.getTemperatureDisplayString(temp: Int(data), units: self.currentUnits, mode: self.cookMode, isThermometer: self.isThermometer)
                pickerView.isSelected = row == self.selectedRow
                pickerView.theme = self.theme
            }) { [weak self] pickerView, data, row in
                self?.selectedRow = row
                pickerView.isSelected = true
                self?.saveValue()
                self?.picker.reloadAllComponents()
            }

        picker.delegate = tempPickerManager
        picker.dataSource = tempPickerManager
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(picker)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            picker.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: shadowRadius + 8),
            picker.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -shadowRadius - 8),
            picker.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: borderWidth + 8),
            picker.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -borderWidth - 8),
            
//            picker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    override func refreshStyling() {
        self.backgroundColor = .clear
        shadowContainer.backgroundColor = theme().tertiaryCookBackground
        shadowView.layer.shadowColor = theme().shadowCookColor.cgColor
        shadowView.layer.borderColor = theme().primaryBackgroundColor.cgColor
    }
}
