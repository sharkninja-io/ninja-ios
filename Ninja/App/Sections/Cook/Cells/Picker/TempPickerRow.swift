//
//  TempPickerRow.swift
//  Ninja
//
//  Created by Martin Burch on 2/7/23.
//

import UIKit

class TempPickerRow: BaseView {
            
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }

    var tempValue: String = "" {
        didSet {
            tempLabel.text = tempValue
        }
    }
    
    var lineCount: Int = 5 {
        didSet {
            generateLines()
            layoutIfNeeded()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @UsesAutoLayout var tempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    @UsesAutoLayout var lineStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = 8
        return stack
    }()
    
    var lines: [UIView] = []
    
    func getNewLine() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorThemeManager.shared.theme.grey03 // TODO: //
        return view
    }
    
    func generateLines() {
        for _ in 1...lineCount {
            lines.append(getNewLine())
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        tempLabel.text = String(tempValue)
        generateLines()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        tempLabel.setStyle(isSelected ? .cookPickerLargeLabel : .cookPickerSmallLabel, theme: theme())
        self.backgroundColor = .clear
    }
    
    override func setupConstraints() {
        
        addSubview(tempLabel)
        addSubview(lineStack)
        
        NSLayoutConstraint.activate([
            tempLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),

            lineStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
//            lineStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            lineStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24)
        ])
        for (index, line) in lines.enumerated() {
            NSLayoutConstraint.activate([
                line.heightAnchor.constraint(equalToConstant: 1),
                line.widthAnchor.constraint(equalToConstant: (index == (lineCount / 2)) ? 56 : 32)
            ])
            lineStack.addArrangedSubview(line)
        }
    }
        
}
