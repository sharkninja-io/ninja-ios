//
//  PickerViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 2/6/23.
//

import UIKit
import Combine

class TimePickerViewCell: CookControlsViewCell {
    
    var timePickerManager: TimePickerManager?
    var selectorItem: CookCellItem<UInt32>?
    var selectedTime: Int?
    
    override var theme: () -> ColorTheme {
        didSet {
            timePickerManager?.theme = theme
        }
    }

    override func connectData(data: CookItem) {
        super.connectData(data: data)

        if let selectorItem = data as? CookCellItem<UInt32> {
            self.selectorItem = selectorItem
            selectorItem.availableValuesSubject.receive(on: DispatchQueue.main).sink { [weak self] values in
                guard let self = self else { return }
                self.timePickerManager?.values = values
                self.picker.reloadAllComponents()
                if selectorItem.currentValueSubject.value == nil {
                    selectorItem.currentValueSubject.send(values.first)
                } else if values.count > 0, let time = self.selectedTime {
                    let index = values.firstIndex(of: UInt32(time)) ?? 0
                    selectorItem.currentValueSubject.send(values[index])
                }
           }.store(in: &disposables)
            selectorItem.currentValueSubject.removeDuplicates().receive(on: DispatchQueue.main).sink { [weak self] current in
                if let current = current {
                    if selectorItem.availableValuesSubject.value.contains(current) {
                        self?.selectTime(value: Int(current))
                    } else if let firstValue = selectorItem.availableValuesSubject.value.first {
                        selectorItem.currentValueSubject.send(firstValue)
                    }
                }
            }.store(in: &disposables)
            selectorItem.unitsSubject.receive(on: DispatchQueue.main).sink { [weak self] units in
                if let units = units {
                    self?.leftLabel.text = (units == "Seconds" ? "MINS".uppercased() : "HOURS".uppercased())
                    self?.rightLabel.text = (units == "Seconds" ? "SEC".uppercased() : "MIN".uppercased())
                    self?.picker.reloadAllComponents()
                }
            }.store(in: &disposables)
        }
    }
    
    func saveValue() {
        let time = timePickerManager?.getTime() ?? 0
       
        if let index = selectorItem?.availableValuesSubject.value.firstIndex(of: UInt32(time)) {
            selectorItem?.currentValueSubject.send(selectorItem?.availableValuesSubject.value[index])
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
    
    @UsesAutoLayout var leftLabel: UILabel = {
        let label = UILabel()
        label.text = "HOURS"
        return label
    }()

    @UsesAutoLayout var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "MIN"
        return label
    }()

    @UsesAutoLayout var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        return label
    }()

    @UsesAutoLayout var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()

    @UsesAutoLayout var titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    @UsesAutoLayout var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.tintColor = .clear
        return picker
    }()
    
    @UsesAutoLayout var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        return stack
    }()
    
    deinit {
        disposables.removeAll()
    }
    
    func selectTime(value: Int) {
        self.selectedTime = value

        let firstRow: Int = timePickerManager?.getRowOfFirst(value: value / 60) ?? 0
        timePickerManager?.selectedFirstRow = firstRow
        let secondRow: Int = timePickerManager?.getRowOfSecond(value: value % 60) ?? 0
        timePickerManager?.selectedSecondRow = secondRow
        // align picker rows
        picker.selectRow(firstRow, inComponent: 0, animated: true)
        picker.selectRow(secondRow, inComponent: 1, animated: true)
        picker.reloadAllComponents()
    }
    
    override func setupViews() {
        super.setupViews()
        self.hideShadow()
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.selectionStyle = .none
        self.accessoryType = .none
        
        timePickerManager = TimePickerManager(selectTime: { [weak self] time in
            self?.saveValue()
        })
        timePickerManager?.theme = theme

        picker.delegate = timePickerManager
        picker.dataSource = timePickerManager
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(picker)
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        self.contentView.addSubview(separatorLabel)

        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            leftLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 32),
            rightLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -32),
            separatorLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            separatorLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

            picker.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: shadowRadius + 8),
            picker.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -shadowRadius - 8),
            picker.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            picker.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.6),
            
//            picker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    override func refreshStyling() {
        self.backgroundColor = .clear
        shadowContainer.backgroundColor = theme().tertiaryCookBackground
        shadowView.layer.shadowColor = theme().shadowCookColor.cgColor
        shadowView.layer.borderColor = theme().primaryBackgroundColor.cgColor

        leftLabel.setStyle(.cookPickerDetailLabel, theme: theme())
        rightLabel.setStyle(.cookPickerDetailLabel, theme: theme())
        separatorLabel.setStyle(.cookPickerLargeLabel, theme: theme())
    }
}
