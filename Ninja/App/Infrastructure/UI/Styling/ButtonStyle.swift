//
//  Style.swift
//  Ninja
//
//  Created by Martin Burch on 9/8/22.
//

import UIKit

struct ButtonStyle {
    var properties: (ColorTheme) -> ButtonStyleProperties
}

struct ButtonStyleProperties {
    var backgroundColor: UIColor?
    var highlightBackgroundColor: UIColor?
    var disabledBackgroundColor: UIColor?
    var background: UIImage?
    var disabledBackground: UIImage?
    var highlightBackground: UIImage?
    var tintColor: UIColor?
    var textColor: UIColor?
    var textDisabledColor: UIColor?
    var textHighlightColor: UIColor?
    var borderColor: UIColor
    var borderWidth: CGFloat
    var cornerRadius: CGFloat
    var font: UIFont
    var icon: UIImage?
    var contentAlignment: UIControl.ContentHorizontalAlignment
    var contentInsets: UIEdgeInsets
    
    init(
        backgroundColor: UIColor? = .clear,
        highlightBackgroundColor: UIColor? = .clear,
        disabledBackgroundColor: UIColor? = .clear,
        background: UIImage? = nil,
        disabledBackground: UIImage? = nil,
        highlightBackground: UIImage? = nil,
        tintColor: UIColor? = ColorThemeManager.shared.theme.primaryTextColor,
        textColor: UIColor? = ColorThemeManager.shared.theme.primaryTextColor,
        textDisabledColor: UIColor? = nil,
        textHighlightColor: UIColor? = nil,
        borderColor: UIColor = .clear,
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = 4,
        font: UIFont = .systemFont(ofSize: 14),
        icon: UIImage? = nil,
        contentAlignment: UIControl.ContentHorizontalAlignment = .center,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    ) {
        self.backgroundColor = backgroundColor
        self.highlightBackgroundColor = highlightBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.background = background
        self.disabledBackground = disabledBackground
        self.highlightBackground = highlightBackground
        self.tintColor = tintColor
        self.textColor = textColor
        self.textDisabledColor = textDisabledColor
        self.textHighlightColor = textHighlightColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.contentInsets = contentInsets
        self.font = font
        self.contentAlignment = contentAlignment
        self.icon = icon
    }
}

extension ButtonStyle {
    
    static var primaryButton = ButtonStyle { theme in
        ButtonStyleProperties(
            background: theme.primaryAccentColor.toImage(),
            disabledBackground: theme.primaryDisabledBackgroundColor.toImage(),
            tintColor: theme.primaryInverseTextColor,
            textColor: theme.primaryInverseTextColor,
            textDisabledColor: theme.primaryDisabledForegroundColor,
            textHighlightColor: theme.primaryInverseTextColor,
            cornerRadius: DefaultSizes.buttonCornerRadius,   // half of button height, 48/2
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16)
        )
    }
    static var secondaryButton = ButtonStyle { theme in
        ButtonStyleProperties(
            backgroundColor: theme.primaryBackgroundColor,
            tintColor: theme.primaryAccentColor,
            textColor: theme.primaryAccentColor,
            textDisabledColor: theme.primaryDisabledBackgroundColor,
            borderColor: theme.primaryAccentColor,
            borderWidth: 1,
            cornerRadius: DefaultSizes.buttonCornerRadius,   // half of button height, 48/2
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16)
        )
    }
    static func coloredButton(foregroundColor: UIColor = .white, backgroundColor: UIColor = .black) -> ButtonStyle {
        return ButtonStyle { theme in
            ButtonStyleProperties(
                background: backgroundColor.toImage(),
                disabledBackground: theme.primaryDisabledBackgroundColor.toImage(),
                tintColor: foregroundColor,
                textColor: foregroundColor,
                textDisabledColor: theme.primaryDisabledForegroundColor,
                textHighlightColor: foregroundColor,
                cornerRadius: DefaultSizes.buttonCornerRadius,   // half of button height, 48/2
                font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16)
            )
        }
    }
    static var linkButton = ButtonStyle { theme in
        ButtonStyleProperties(
            textDisabledColor: theme.secondaryTextColor,
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            contentInsets: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        )
    }
    static var accentedLinkButton = ButtonStyle { theme in // 500
        ButtonStyleProperties(
            textColor: theme.primaryAccentColor,
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16),
            contentInsets: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        )
    }
    static var checkboxCenteredButton = ButtonStyle { theme in
        ButtonStyleProperties(
            tintColor: theme.secondaryTextColor,
            textColor: theme.secondaryTextColor,
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12), // 400m, 4a4a53
            contentInsets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        )
    }
    static var checkboxLeadingAlignedButton = ButtonStyle { theme in
        ButtonStyleProperties(
            tintColor: theme.secondaryTextColor,
            textColor: theme.secondaryTextColor,
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12), // 400m, 4a4a53
            contentAlignment: .leading,
            contentInsets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        )
    }
    
    static var destructivePrimaryButton = ButtonStyle { theme in
        ButtonStyleProperties(
            background: theme.primaryErrorForegroundColor.toImage(),
            disabledBackground: theme.primaryDisabledForegroundColor.toImage(),
            textColor: theme.primaryInverseTextColor,
            cornerRadius: DefaultSizes.buttonCornerRadius,
            font: FontFamilyLibrary.gotham_medium.asFont(size: 18) ?? .systemFont(ofSize: 18)
        )
    }
    
    static var destructiveSecondaryButton = ButtonStyle { theme in
        ButtonStyleProperties(
            backgroundColor: theme.primaryBackgroundColor,
            textColor: theme.primaryErrorForegroundColor,
            textDisabledColor: theme.primaryDisabledBackgroundColor,
            borderColor: theme.primaryErrorForegroundColor,
            borderWidth: 1,
            cornerRadius: DefaultSizes.buttonCornerRadius,
            font: FontFamilyLibrary.gotham_medium.asFont(size: 18) ?? .systemFont(ofSize: 18)
        )
    }
    
    static var destructiveTertiaryButton = ButtonStyle { theme in
        ButtonStyleProperties(
            backgroundColor: theme.primaryForegroundColor,
            textColor: theme.primaryInverseTextColor,
            cornerRadius: DefaultSizes.buttonCornerRadius,
            font: FontFamilyLibrary.gotham_medium.asFont(size: 18) ?? .systemFont(ofSize: 18)
        )
    }
    
    static var destructiveLinkButton = ButtonStyle { theme in
        ButtonStyleProperties(
            textColor: theme.primaryErrorForegroundColor,
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        )
    }
    
    static var blackButton = ButtonStyle { theme in
        ButtonStyleProperties(
            background: theme.black01.toImage(),
            disabledBackground: theme.grey02.toImage(),
            tintColor: theme.white01,
            textColor: theme.white01,
            textDisabledColor: theme.grey01,
            textHighlightColor: theme.grey04,
            cornerRadius: DefaultSizes.buttonCornerRadius,   // half of button height, 48/2
            font: FontFamilyLibrary.gotham_medium.asFont(size: 18) ?? .systemFont(ofSize: 18)
        )
    }
    
    static func transparentButton(foregroundColor: UIColor = 0xFFFFFF.hexToUIColor().withAlphaComponent(0.5), backgroundColor: UIColor = .clear) -> ButtonStyle {
        return ButtonStyle { theme in
            ButtonStyleProperties(
                background: backgroundColor.toImage(),
                highlightBackground: foregroundColor.withAlphaComponent(0.2).toImage(),
                tintColor: foregroundColor,
                textColor: foregroundColor,
                textHighlightColor: foregroundColor,
                borderColor: foregroundColor,
                borderWidth: 1,
                cornerRadius: DefaultSizes.buttonCornerRadius,   // half of button height, 48/2
                font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16)
            )
        }
    }
    
    static var tabButton = ButtonStyle { theme in
        ButtonStyleProperties(
            background: theme.primaryBackgroundColor.toImage(),
            highlightBackground: theme.primaryBackgroundColor.toImage(),
            tintColor: theme.grey03,
            textColor: theme.grey03,
            textHighlightColor: theme.primaryTextColor,
            cornerRadius: 0,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12)
        )
    }
    static func ovalTabButton(borderColor: UIColor?) -> ButtonStyle {
        return ButtonStyle { theme in
            ButtonStyleProperties(
                backgroundColor: .clear,
                highlightBackgroundColor: theme.cookSelectedForeground,
                tintColor: theme.grey01,
                textColor: theme.grey01,
                textHighlightColor: theme.primaryInverseTextColor,
                borderColor: borderColor ?? theme.cookSelectedForeground,
                borderWidth: 1,
                cornerRadius: DefaultSizes.buttonCornerRadius,
                font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12)
            )
        }
    }
    
    static var circularTabButton = ButtonStyle { theme in
        ButtonStyleProperties(
            backgroundColor: theme.tertiaryCookBackground,
            highlightBackgroundColor: theme.primaryAccentColor,
            disabledBackgroundColor: theme.primaryDisabledBackgroundColor,
            tintColor: theme.primaryBackgroundColor,
            textColor: theme.grey02,
            textDisabledColor: theme.primaryDisabledForegroundColor,
            textHighlightColor: theme.primaryTextColor,
            cornerRadius: 0,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12)
        )
    }
    static var dropdownButton = ButtonStyle { theme in
        ButtonStyleProperties(
            textColor: theme.primaryTextColor,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            icon: IconAssetLibrary.ico_chevron_down.asImage()?.tint(color: theme.primaryTextColor),
            contentInsets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 16)
        )
    }
    
    static var dropdownButtonSelected = ButtonStyle { theme in
        ButtonStyleProperties(
            textColor: theme.primaryTextColor,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            icon: IconAssetLibrary.ico_arrow_up.asImage()?.tint(color: theme.primaryTextColor),
            contentInsets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 16)
        )
    }
    static var navBackButton = ButtonStyle { theme in
        ButtonStyleProperties(
            textColor: theme.primaryTextColor,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            icon: IconAssetLibrary.ico_back_button.asImage()?.tint(color: theme.primaryTextColor),
            contentInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0)
        )
    }
    
    static var backButton = ButtonStyle { theme in
        ButtonStyleProperties(
            backgroundColor: theme.primaryBackgroundColor,
            tintColor: theme.primaryTextColor,
            textColor: theme.primaryTextColor,
            textDisabledColor: theme.primaryDisabledBackgroundColor,
            borderColor: theme.primaryAccentColor,
            borderWidth: 0,
            cornerRadius: 0,
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16)
        )
    }
    
}
