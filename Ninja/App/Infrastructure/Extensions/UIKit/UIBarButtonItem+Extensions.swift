//
//  UIBarButton+Extensions.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/25/22.
//

import UIKit

extension UIBarButtonItem {
    
    func setStyle(_ style: BarButtonStyle, theme: ColorTheme = ColorThemeManager.shared.theme) {
        let props = style.properties(theme)
        self.tintColor = props.tintColor
        self.setTitleTextAttributes([.font: props.font], for: .normal)
    }
    
}
