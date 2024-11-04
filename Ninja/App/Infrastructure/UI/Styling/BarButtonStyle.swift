//
//  BarButtonStyle.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/25/22.
//

import UIKit

struct BarButtonStyle {
    var properties: (ColorTheme) -> BarButtonStyleProperties
}

struct BarButtonStyleProperties {
    var tintColor: UIColor
    var font: UIFont
}

extension BarButtonStyle {
    static var primaryBarButton = BarButtonStyle { theme in
        BarButtonStyleProperties(
            tintColor: theme.primaryTextColor,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16)
        )
    }
}
