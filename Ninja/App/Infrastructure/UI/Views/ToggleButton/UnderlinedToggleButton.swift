//
//  UnderlinedToggleButton.swift
//  Ninja
//
//  Created by Martin Burch on 12/29/22.
//

import UIKit

@IBDesignable
class UnderlinedToggleButton: BaseToggleButton {
    
    var border: UIView = {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    var highlightColor: UIColor? = ColorThemeManager.shared.theme.primaryAccentColor.withAlphaComponent(0.2)

    convenience init(title: String, identifier: Any? = nil) {
        self.init()
        label.text = title
        self.identifier = identifier
        
        addTouchAnimation()
    }
    
    override func updateState() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = self.isSet ? self.setBackgroundColor : self.unsetBackgroundColor
            self.label.textColor = self.isSet ? self.setTextColor : self.unsetTextColor
            self.label.font = self.isSet ? self.setFont : self.unsetFont
            self.border.backgroundColor = self.isSet ? self.setTextColor : self.unsetTextColor
        }
    }
        
    private func addTouchAnimation() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTouchDown))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTouchDown(sender: UITapGestureRecognizer) {
        super.onTap(sender: sender)
        if isEnabled {
            guard sender.view != nil else { return }
            
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self = self else { return }
                self.backgroundColor = self.highlightColor
            }, completion: { [weak self] done in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.1) {
                    self.backgroundColor = self.isSet ? self.setBackgroundColor : self.unsetBackgroundColor
                }
            })
        }
    }
    
    override func setupConstraints() {
        addSubview(label)
        addSubview(border)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: border.topAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            border.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            border.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            border.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
