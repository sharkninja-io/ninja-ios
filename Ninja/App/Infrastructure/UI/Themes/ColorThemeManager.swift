//
//  ColorThemeManager.swift
//  SharkClean
//
//  Created by Jonathan on 2/14/22.
//

import UIKit

struct ColorThemeManager {

    public static var shared: ColorThemeManager = .init()
    
    private var lightColorTheme: ColorTheme = LightColorTheme()
    private var darkColorTheme: ColorTheme = DarkColorTheme()
    
    var monitorControlTheme: ColorTheme = MonitorControlTheme()
    
    var currentStyle: UIUserInterfaceStyle {
        return UITraitCollection.current.userInterfaceStyle
    }

    private init() {}

    public var theme: ColorTheme {
//        switch UITraitCollection.current.userInterfaceStyle {
//        case .light:
            return lightColorTheme
//        case .dark:
//            return darkColorTheme
//        case .unspecified:
//            return lightColorTheme
//        @unknown default:
//            return lightColorTheme
//        }
    }

}
