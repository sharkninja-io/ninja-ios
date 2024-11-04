//
//  MultiToggleButtonGroup.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/15/23.
//

import UIKit

@IBDesignable
class MultiToggleButtonGroup : UIControl {
    
    var controller: MultiToggleButtonGroupController = .init()
    
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
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        controller.onSelectCallback = { [weak self] control in
            self?.sendActions(for: .valueChanged)
            self?.sendActions(for: .primaryActionTriggered)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func addButtons(_ buttonList: [BaseToggleButton]) {
        controller.addButtons(buttonList)
        buttonList.forEach { button in
            stackView.addArrangedSubview(button)
        }
    }
        
    func selectButton(_ toggleButton: BaseToggleButton?) {
        guard let toggleButton = toggleButton else { return }

        if controller.selectButton(toggleButton) {
            self.sendActions(for: .valueChanged)
            self.sendActions(for: .primaryActionTriggered)
        }
    }
    
}
