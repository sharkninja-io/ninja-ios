//
//  AlertModalView.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/21/22.
//

import Foundation

import UIKit

class AlertModalView: SimpleModalView {
    
    @UsesAutoLayout private var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    @UsesAutoLayout public var secondaryButton = UIButton()
    @UsesAutoLayout public var primaryButton = UIButton()
    
    private var manager: AlertManager?
            
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            primaryButton.heightAnchor.constraint(equalToConstant: 48),
            secondaryButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        if let secondary = manager?.secondaryAction {
            secondaryButton.setStyle(secondary.buttonStyle)
        }
        
        if let primary = manager?.primaryAction {
            primaryButton.setStyle(primary.buttonStyle)
        }
    }
    
    override func applyAttributes(_ manager: SimpleModalManager) {
        guard let manager = manager as? AlertManager else { return }
        self.manager = manager
        super.applyAttributes(manager)
        
        if let primary = manager.primaryAction {
            primaryButton.setTitle(primary.title, for: .normal)
            buttonStack.addArrangedSubview(primaryButton)
        }
        
        if let secondary = manager.secondaryAction {
            secondaryButton.setTitle(secondary.title, for: .normal)
            buttonStack.addArrangedSubview(secondaryButton)
        }
        
        mainStack.addArrangedSubview(buttonStack)
    }
}
