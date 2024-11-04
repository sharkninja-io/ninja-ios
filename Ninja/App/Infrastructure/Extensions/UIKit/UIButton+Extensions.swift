//
//  UIButton+Style.swift
//  Ninja
//
//  Created by Martin Burch on 9/8/22.
//

import UIKit

extension UIButton {

    func setStyle(_ style: ButtonStyle, theme: ColorTheme = ColorThemeManager.shared.theme) {
        let props = style.properties(theme)
        // Common setup settings
        self.clipsToBounds = true
        if #available(iOS 15.0, *) {
            self.configuration = nil // default
        } else {
//            self.adjustsImageWhenHighlighted = false
        }
        
        self.backgroundColor = props.backgroundColor
        self.setBackgroundImage(props.background, for: .normal)
        self.setBackgroundImage(props.disabledBackground, for: .disabled)
        if let highlightColor = props.highlightBackground {
            self.setBackgroundImage(highlightColor, for: .focused)
            self.setBackgroundImage(highlightColor, for: .highlighted)
            self.setBackgroundImage(highlightColor, for: .selected)
        }
        
        self.setTitleColor(props.textColor, for: .normal)
        self.setTitleColor(props.textDisabledColor, for: .disabled)
        if let textHighlightColor = props.textHighlightColor {
            self.setTitleColor(textHighlightColor, for: .focused)
            self.setTitleColor(textHighlightColor, for: .highlighted)
            self.setTitleColor(textHighlightColor, for: .selected)
        }
        self.titleLabel?.font = props.font
        self.contentHorizontalAlignment = props.contentAlignment
         
        self.layer.borderColor = props.borderColor.cgColor
        self.layer.borderWidth = props.borderWidth
        self.layer.cornerRadius = props.cornerRadius
        self.contentEdgeInsets = props.contentInsets
        
        if let icon = props.icon {
            self.setImage(icon, for: .normal)
        }
        self.imageView?.tintColor = props.tintColor
    }
    
    
    /// https://stackoverflow.com/questions/4564621/aligning-text-and-image-on-uibutton-with-imageedgeinsets-and-titleedgeinsets
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        if isRTL {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
           contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
        } else {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
           contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
    
    func addRightLabel(value: String, spacing: CGFloat) {
        let label = UILabel()
        label.text = value
        label.setStyle(.alertSubtitle)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        titleEdgeInsets.right += spacing

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            label.widthAnchor.constraint(equalToConstant: spacing),
            label.heightAnchor.constraint(equalToConstant: spacing)
        ])
    }
}
