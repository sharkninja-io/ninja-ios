//
//  UITextField.swift
//  Ninja
//
//  Created by Martin Burch on 9/21/22.
//

import UIKit

extension UITextField {
    func setStyle(_ style: TextFieldStyle, theme: ColorTheme = ColorThemeManager.shared.theme) {
        let props = style.properties(theme)
        self.background = props.background
        self.backgroundColor = props.backgroundColor
        self.disabledBackground = props.disabledBackground
        
        self.font = props.font
        self.textColor = props.textColor
        self.textAlignment = props.textAlignment
        
        self.borderStyle = props.borderStyle
        self.layer.borderColor = props.borderColor.cgColor
        self.layer.borderWidth = props.borderWidth
        self.layer.cornerRadius = props.cornerRadius

        self.textContentType = props.textContentType
        self.keyboardType = props.keyboardType
        self.autocapitalizationType = props.autocapitalizationType
        self.autocorrectionType = props.autocorrectionType
    }
}
