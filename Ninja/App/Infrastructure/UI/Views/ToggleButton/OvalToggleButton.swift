//
//  OvalToggleButton.swift
//  Ninja
//
//  Created by Martin Burch on 5/10/23.
//

import UIKit

@IBDesignable
class OvalToggleButton: BaseToggleButton {
    
    var highlightColor: UIColor? = ColorThemeManager.shared.theme.primaryAccentColor.withAlphaComponent(0.2)
    
    var setBorderColor: UIColor? = ColorThemeManager.shared.theme.primaryAccentColor {
        didSet {
            updateState()
        }
    }
    var borderWidth: CGFloat = 0 {
        didSet {
            updateState()
        }
    }

    convenience init(title: String, identifier: Any? = nil) {
        self.init()
        label.text = title
        self.identifier = identifier
    }
    
    override func updateState() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = self.isSet ? self.setBackgroundColor : self.unsetBackgroundColor
            self.label.textColor = self.isSet ? self.setTextColor : self.unsetTextColor
            self.label.font = self.isSet ? self.setFont : self.unsetFont
            self.layer.shadowOpacity = self.isSet ? 0.2 : 0.0
            self.layer.borderWidth = self.borderWidth
            self.layer.borderColor = self.isSet ? self.setBorderColor?.cgColor : self.unsetBackgroundColor?.cgColor
        }
    }
    
    override func setStyle(_ style: ButtonStyle, theme: ColorTheme = ColorThemeManager.shared.theme) {
        super.setStyle(style, theme: theme)
        
        let props = style.properties(theme)
        self.borderWidth = props.borderWidth
        self.setBorderColor = props.borderColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isEnabled {
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self = self else { return }
                self.backgroundColor = self.highlightColor
            })
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if isEnabled {
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self = self else { return }
                self.updateState()
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isEnabled {
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self = self else { return }
                self.updateState()
            })
        }
    }
    
    override func setup() {
        super.setup()
        
        self.layer.cornerRadius = DefaultSizes.buttonCornerRadius
        self.layer.shadowColor = ColorThemeManager.shared.theme.black01.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 6
    }
    
    override func setupConstraints() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
}
