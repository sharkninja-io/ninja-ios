//
//  ToggleButtonGroupView.swift
//  Ninja
//
//  Created by Martin Burch on 11/4/22.
//

import UIKit

@IBDesignable
class ToggleButtonGroup : UIControl {
    
    var controller: ToggleButtonGroupController = .init()
    
    var selectedButton: BaseToggleButton? {
        get {
            return controller.selectedButton
        }
    }
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.clipsToBounds = true
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    var buttonList: [BaseToggleButton] {
        get {
            controller.buttonList
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        self.stackView.clipsToBounds = false
        self.stackView.layer.masksToBounds = false
        self.backgroundColor = .clear
        
        controller.onSelectCallback = { [weak self] control in
            self?.sendActions(for: .valueChanged)
            self?.sendActions(for: .primaryActionTriggered)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1)
        ])
    }
    
    func setStyle(backgroundColor: UIColor,
                  borderWidth: CGFloat,
                  borderColor: UIColor,
                  cornerRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    func addButtons(_ buttonList: [BaseToggleButton]) {
        controller.addButtons(buttonList)
        buttonList.forEach { button in
            stackView.addArrangedSubview(button)
        }
    }
        
    func selectButton(_ toggleButton: BaseToggleButton?, doSendAction: Bool = true) {
        guard let toggleButton = toggleButton else { return }

        if controller.selectButton(toggleButton) {
            if doSendAction {
                self.sendActions(for: .valueChanged)
                self.sendActions(for: .primaryActionTriggered)
            }
        }
    }
    
    func selectButton(doSendAction: Bool = true, completion: (BaseToggleButton) -> Bool) {
        buttonList.forEach { button in
            if completion(button) {
                selectButton(button, doSendAction: doSendAction)
            }
        }
    }
}
