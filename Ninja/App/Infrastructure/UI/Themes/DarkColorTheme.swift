//
//  DarkColorTheme.swift
//  Ninja
//
//  Created by Martin Burch on 8/26/22.
//

import UIKit

// TODO:
struct DarkColorTheme: ColorTheme {
    
    var primaryBackgroundColor: UIColor = 0x000000.hexToUIColor()
    var secondaryBackgroundColor: UIColor = 0x111111.hexToUIColor()
    
    var primaryForegroundColor: UIColor = 0xFFFFFF.hexToUIColor()
    var secondaryForegroundColor: UIColor = 0xE5E5E5.hexToUIColor()
    
    var primaryAccentColor: UIColor = 0x45BE55.hexToUIColor()
    var tertiaryAccentColor: UIColor = 0x9BE481.hexToUIColor()
    
    var primaryTextColor: UIColor = 0xFFFFFF.hexToUIColor()
    var secondaryTextColor: UIColor = 0xE5E5E5.hexToUIColor()
    var tertiaryTextColor: UIColor = 0x767676.hexToUIColor()
    
    var primaryInverseTextColor: UIColor = 0x000000.hexToUIColor()
    var secondaryInverseTextColor: UIColor = 0x111111.hexToUIColor()

    var primaryDisabledBackgroundColor: UIColor = 0xE5E5E5.hexToUIColor()
    var primaryDisabledForegroundColor: UIColor = 0x9F9F9F.hexToUIColor()

    var primaryErrorForegroundColor: UIColor = 0xFFAACC.hexToUIColor() // TODO: //
    var primaryErrorBackgroundColor: UIColor = 0xF52A4C.hexToUIColor(alpha: 0.1)
    
    var primaryCookForeground: UIColor = 0xFFFFFF.hexToUIColor()
    var secondaryCookForeground: UIColor = 0xE5E5E5.hexToUIColor()
    var primaryCookBackground: UIColor = 0x000000.hexToUIColor()
    var secondaryCookBackground: UIColor = 0x181818.hexToUIColor()
    var tertiaryCookBackground: UIColor = 0x181818.hexToUIColor().withAlphaComponent(0.35)
    var shadowCookColor: UIColor = 0x000000.hexToUIColor()
    var cellCookBackground: UIColor = 0x000000.hexToUIColor()
    var modalBackground: UIColor = 0x181818.hexToUIColor()
    var cookSelectedForeground: UIColor = 0x45BE55.hexToUIColor()
    var cookToggleBorderColor: UIColor = 0x181818.hexToUIColor()

    var black01: UIColor = 0x181818.hexToUIColor()
    var white01: UIColor = 0xFFFFFF.hexToUIColor()
    var grey01: UIColor = 0xF7F7F7.hexToUIColor()
    var grey02: UIColor = 0xE5E5E5.hexToUIColor()
    var grey03: UIColor = 0x767676.hexToUIColor()
    var grey04: UIColor = 0x333333.hexToUIColor()
    var purple01: UIColor = 0x6070FD.hexToUIColor()

    var primaryWarmAccentColor: UIColor = 0xE6CD98.hexToUIColor()
    var secondaryWarmAccentColor: UIColor = 0xDCA26E.hexToUIColor()
    var tertiaryWarmAccentColor: UIColor = 0xD27843.hexToUIColor()
    var quaternaryWarmAccentColor: UIColor = 0xD55743.hexToUIColor()
    var primaryAlternateAccentColor: UIColor = 0x6070FD.hexToUIColor()

}