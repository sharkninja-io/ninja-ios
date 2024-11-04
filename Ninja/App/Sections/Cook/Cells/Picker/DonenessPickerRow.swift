//
//  TempPickerRow.swift
//  Ninja
//
//  Created by Martin Burch on 2/7/23.
//

import UIKit

class DonenessPickerRow: BaseView {
            
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }

    var tempValue: String = "" {
        didSet {
            tempLabel.text = tempValue
        }
    }
    
    var donenessValue: String = "" {
        didSet {
            donenessLabel.text = donenessValue
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @UsesAutoLayout var donenessLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    @UsesAutoLayout var tempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    @UsesAutoLayout var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorThemeManager.shared.theme.grey03 // TODO: //
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        tempLabel.text = String(tempValue)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        tempLabel.setStyle(isSelected ? .cookPickerLargeLabel : .cookPickerSmallLabel, theme: theme())
        donenessLabel.setStyle(isSelected ? .donenessLevelSelectedLabel : .cookPickerSmallLabel, theme: theme())
// TODO:        line.widthAnchor.constraint(equalToConstant: isSelected ? 56 : 32).isActive = true
        self.backgroundColor = .clear
    }
    
    override func setupConstraints() {
        
        addSubview(tempLabel)
        addSubview(donenessLabel)
        addSubview(line)
        
        NSLayoutConstraint.activate([
            donenessLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            donenessLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            
            line.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            line.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            line.widthAnchor.constraint(equalToConstant: 32),
            line.heightAnchor.constraint(equalToConstant: 1),

            tempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
        ])
    }
        
}
