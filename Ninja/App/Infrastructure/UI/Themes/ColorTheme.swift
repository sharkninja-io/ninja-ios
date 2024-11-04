//
//  ColorTheme.swift
//  Ninja
//
//  Created by Martin Burch on 8/26/22.
//

import UIKit

protocol ColorTheme {
        
    var primaryBackgroundColor: UIColor { get set }
    var secondaryBackgroundColor: UIColor { get set }
    
    var primaryForegroundColor: UIColor { get set }
    var secondaryForegroundColor: UIColor { get set }
    
    var primaryAccentColor: UIColor { get set }
    var tertiaryAccentColor: UIColor { get set }
    
    var primaryTextColor: UIColor { get set }
    var secondaryTextColor: UIColor { get set }
    var tertiaryTextColor: UIColor { get set }
    
    var primaryInverseTextColor: UIColor { get set }
    var secondaryInverseTextColor: UIColor { get set }

    var primaryDisabledBackgroundColor: UIColor { get set }
    var primaryDisabledForegroundColor: UIColor { get set }
    
    /// The fullest red for errors and destructive actions
    var primaryErrorForegroundColor: UIColor { get set }
    var primaryErrorBackgroundColor: UIColor { get set }
    
    var primaryCookForeground: UIColor { get set }
    var secondaryCookForeground: UIColor { get set }
    var primaryCookBackground: UIColor { get set }
    var secondaryCookBackground: UIColor { get set }
    var tertiaryCookBackground: UIColor { get set }
    var shadowCookColor: UIColor { get set }
    var cellCookBackground: UIColor { get set }
    var modalBackground: UIColor { get set }
    var cookSelectedForeground: UIColor { get set }
    var cookToggleBorderColor: UIColor { get set }

    var black01: UIColor { get set }
    var white01: UIColor { get set }
    var grey01: UIColor { get set }
    var grey02: UIColor { get set }
    var grey03: UIColor { get set }
    var grey04: UIColor { get set }
    var purple01: UIColor { get set }

    var primaryWarmAccentColor: UIColor { get set }
    var secondaryWarmAccentColor: UIColor { get set }
    var tertiaryWarmAccentColor: UIColor { get set }
    var quaternaryWarmAccentColor: UIColor { get set }
    var primaryAlternateAccentColor: UIColor { get set }

}
