//
//  UIFont+FamilyLibrary.swift
//  Ninja
//
//  Created by Martin Burch on 9/22/22.
//

import UIKit

enum FontFamilyLibrary: String {
    case gotham_black = "Gotham-Black"
    case gotham_black_italic = "Gotham-BlackItalic"
    case gotham_bold = "Gotham-Bold"
    case gotham_bold_italic = "Gotham-BoldItalic"
    case gotham_book = "Gotham-Book"
    case gotham_book_italic = "Gotham-BookItalic"
    case gotham_extra_light = "Gotham-ExtraLight"
    case gotham_extra_light_italic = "Gotham-ExtraLightItalic"
    case gotham_light = "Gotham-Light"
    case gotham_light_italic = "Gotham-LightItalic"
    case gotham_medium = "Gotham-Medium"
    case gotham_medium_italic = "Gotham-MediumItalic"
    case gotham_thin = "Gotham-Thin"
    case gotham_thin_italic = "Gotham-ThinItalic"
    case gotham_ultra = "Gotham-Ultra"
    case gotham_ultra_italic = "Gotham-UltraItalic"
    case proxima_nova_bold = "ProximaNovaBold"
    case proxima_nova_light = "ProximaNovaLight"
    case proxima_nova_regular = "ProximaNovaRegular"
    case proxima_nova_semibold = "ProximaNovaSemibold"
    
    func asFont(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
}

