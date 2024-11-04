//
//  LabelStyle.swift
//  Ninja
//
//  Created by Martin Burch on 9/21/22.
//

import UIKit

struct LabelStyle {
    var properties: (ColorTheme) -> LabelStyleProperties
}

struct LabelStyleProperties {
    var font: UIFont
    var textColor: UIColor?
    var textAlignment: NSTextAlignment
    var lineBreakMode: NSLineBreakMode
    var numberOfLines: Int
    var adjustsFontSizeToFitWidth: Bool
    var minimumScaleFactor: CGFloat
    var allowsDefaultTighteningForTruncation: Bool
    
    init(
        font: UIFont = .systemFont(ofSize: 16),
        textColor: UIColor? = ColorThemeManager.shared.theme.primaryTextColor,
        textAlignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        numberOfLines: Int = 0,
        adjustsFontSizeToFitWidth: Bool = false,
        minimumScaleFactor: CGFloat = 1,
        allowsDefaultTighteningForTruncation: Bool = false
    ) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.minimumScaleFactor = minimumScaleFactor
        self.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
    }
}

extension LabelStyle {
    /// Gotham Medium 16px, PrimaryErrorForegroundColor, Left alignment
    static var errorLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryErrorForegroundColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 12px, SecondaryTextColor, Left alignment
    static var itemLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.secondaryTextColor,
            textAlignment: .left
        )
    }
    /// Gothm Medium 18px, Left alignment
    static var collectionViewCellLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 18) ?? .systemFont(ofSize: 18),
            textAlignment: .left
        )
    }
    /// Gotham Book 16px. Left Alignment
    static var selectApplianceTableViewCellLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textAlignment: .left
        )
    }
    
    /// Gotham Book 28px, Left alignment
    static var titleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 28) ?? .systemFont(ofSize: 20),
            textAlignment: .left
        )
    }
    /// Gotham Book 20px, SecondaryTextColor, Left alignment
    static var subtitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 20) ?? .systemFont(ofSize: 20),
            textColor: theme.secondaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 16px, SecondaryTextColor, Left alignment
    static var infoLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Bold 24px, SecondaryTextColor, Left alignment
    static var headerTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.secondaryTextColor,
            textAlignment: .left
        )
    }
    
    // MARK: Components
    /// Gotham Book 12px, TertiaryTextColor, Left alignment
    static var textFieldTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.tertiaryTextColor,
            textAlignment: .left
        )
    }
    
    /// Gotham Book 12px, Left alignment
    static var textFieldMessageLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: nil,
            textAlignment: .left
        )
    }
    
    /// Gotham Book 12px, PrimaryTextColor, Left alignment
    static var pageIndicatorLabel = LabelStyle { theme in // 500, green/c4c4c4
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Bold 12px, PrimaryTextColor, Left alignment
    static var pageIndicatorTitleLabel = LabelStyle { theme in // 700, green
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    ///
    static var callToActionTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryTextColor
        )
    }
    // MARK: Authentication
    /// Gotham Book 24px, PrimaryTextColor, Left alignment
    static var authTitleLabel = LabelStyle { theme in // 400, 181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 16px, SecondaryTextColor, Left alignment
    static var authSubtitleLabel = LabelStyle { theme in // 400, 767676
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 12px, SecondaryTextColor, Left alignment
    static var authInfoLabel = LabelStyle { theme in // 400, 767676
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.secondaryTextColor,
            textAlignment: .left
        )
    }

    
    // MARK: Pairing
    /// Gotham Bold 32px, Black01 color, Center alignment
    static var pairingSplashTitleLabel = LabelStyle { theme in // 700, 181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 32) ?? .systemFont(ofSize: 32),
            textColor: theme.black01,
            textAlignment: .center
        )
    }
    /// Gotham Book 32px, Black01 color, Center alignment
    static var pairingSplashInfoLabel = LabelStyle { theme in // 400, 181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 32) ?? .systemFont(ofSize: 32),
            textColor: theme.black01,
            textAlignment: .center
        )
    }
    /// Gotham Book 24px, PrimaryTextColor
    static var pairingTitleLabel = LabelStyle { theme in // 400, black/181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.primaryTextColor
        )
    }
    /// Gotham Book 12px, SecondaryTextColor
    static var pairingInfoLabel = LabelStyle { theme in // 400, 767676
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.secondaryTextColor
        )
    }
    /// Gotham Book 14px, SecondaryTextColor
    static var pairingLargeInfoLabel = LabelStyle { theme in // 400, 555555
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 14) ?? .systemFont(ofSize: 14),
            textColor: theme.secondaryTextColor
        )
    }
    /// Gotham Book 16px, SecondaryTextColor
    static var pairingLargestInfoLabel = LabelStyle { theme in // 400, 767676
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor
        )
    }
    /// Gotham Book 12px, TertiaryTextColor
    static var pairingLightestInfoLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.tertiaryTextColor
        )
    }
    /// Gotham Bold 12px, TertiaryWarmAccentColor
    static var pairingWarningLabel = LabelStyle { theme in // 700, d27843
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.tertiaryWarmAccentColor
        )
    }
    /// Gotham Bold 16px, TertiaryWarmAccentColor
    static var pairingItemTitleLabel = LabelStyle { theme in // 500, black/181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.tertiaryWarmAccentColor
        )
    }
    /// Gotham Bold 16px, PrimaryTextColor
    static var pairingPageTitleLabel = LabelStyle { theme in // 500, black/181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryTextColor
        )
    }
    /// Gotham Bold 12px, PrimaryTextColor
    static var pairingPageTitleSmallLabel = LabelStyle { theme in // 500, black/181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor
        )
    }
    /// Gotham Bold 14px, PrimaryTextColor
    static var pairingWifiItemLabel = LabelStyle { theme in // 400, black/181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 14) ?? .systemFont(ofSize: 14),
            textColor: theme.primaryTextColor
        )
    }
    /// Gotham Book 14px, SecondaryTextColor
    static var pairingWifiInfoLabel = LabelStyle { theme in // 400, 4a4a53
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 14) ?? .systemFont(ofSize: 14),
            textColor: theme.secondaryTextColor
        )
    }
    /// Gotham Bold 16px, SecondaryTextColor
    static var pairingWifiTitleLabel = LabelStyle { theme in // 700, 181818
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor
        )
    }
    static var pairingLargestInfoNormalLabel = LabelStyle { theme in // 400, 767676
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor
        )
    }
    static var pairingWhiteOverlayTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 48) ?? .systemFont(ofSize: 48),
            textColor: theme.white01
        )
    }
    static var pairingWhiteOverlayInfoLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.white01
        )
    }
    
    static var wifiPairingWhiteOverlayInfoLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.white01
        )
    }
    
    // MARK: COOK
    static var cookGroupTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor
        )
    }
    static var cookGroupTitleOff = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.grey03
        )
    }
    static var cookCellTitleBold = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor
        )
    }
    static var cookCellTitleBoldAdjustable = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor,
            numberOfLines: 1,
            adjustsFontSizeToFitWidth: true,
            minimumScaleFactor: 0.6
        )
    }
    static var cookCellTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.secondaryTextColor
        )
    }
    static var cookCellTemp = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.secondaryTextColor
        )
    }
    static var cookCellInfo = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.secondaryTextColor
        )
    }
    static var cookCellSimpleTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 24) ?? .systemFont(ofSize: 12),
            textColor: theme.grey01
        )
    }
    static var cookCellDetailItem = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.grey01
        )
    }
    static var cookPickerLargeLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 32) ?? .systemFont(ofSize: 32, weight: .bold),
            textColor: theme.primaryTextColor,
            textAlignment: .center
        )
    }
    static var cookPickerSmallLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.tertiaryTextColor,
            textAlignment: .center
        )
    }
    static var cookPickerDetailLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor
        )
    }
    static var cookCallToActionLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryTextColor
        )
    }
    static var cookModalTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.primaryTextColor,
            textAlignment: .center
        )
    }
    static var cookModalDescriptionLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.primaryTextColor,
            textAlignment: .center
        )
    }
    static var miniCookCellLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryForegroundColor
        )
    }
    static var donenessPickerTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.tertiaryTextColor,
            textAlignment: .center
        )
    }
    static var donenessLevelSelectedLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .bold),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    static var donenessLevelDeselectedLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .bold),
            textColor: theme.tertiaryTextColor,
            textAlignment: .left
        )
    }
    
    static func cookPillStatus(textColor: UIColor? = nil) -> LabelStyle {
        return LabelStyle { theme in
            LabelStyleProperties(
                font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
                textColor: textColor ?? theme.white01,
                numberOfLines: 1
            )
        }
    }
    
    static var thermometerCtaTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.primaryTextColor,
            adjustsFontSizeToFitWidth: true
        )
    }
    static var thermometerCtaInfoLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor,
            numberOfLines: 0
        )
    }
    static var cookProgressValueLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 48) ?? .systemFont(ofSize: 48),
            textColor: theme.white01,
            textAlignment: .center
        )
    }
    static var cookProgressInfoLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.white01
        )
    }
    static func cookProgressStateLabel(textColor: UIColor) -> LabelStyle {
        return LabelStyle { theme in
            LabelStyleProperties(
                font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
                textColor: textColor
            )
        }
    }
    static var cookToastTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.primaryTextColor
        )
    }
    static var cookToastMessageLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12, weight: .regular),
            textColor: theme.primaryTextColor
        )
    }

    // MARK: Settings
    /// Gotham Medium 16px, PrimaryTextColor, Center alignment
    static var alertTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.primaryTextColor,
            textAlignment: .center
        )
    }
    /// Gotham Book 16px, PrimaryTextColor, Center alignment
    static var alertSubtitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryTextColor,
            textAlignment: .center
        )
    }
    /// Gotham Bold 12px, PrimaryTextColor, Left alignment
    static var settingsTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12, weight: .bold),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 24px, PrimaryTextColor, Left alignment
    static var settingsSubtitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 12px, PrimaryTextColor, Center alignment
    static var settingsDescriptionLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor,
            textAlignment: .center
        )
    }
    /// Gotham Book 12px, TertiaryTextColor, Left alignment, `adjustsFontSizeToFitWidth`
    static var settingsItemLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.tertiaryTextColor,
            textAlignment: .left,
            adjustsFontSizeToFitWidth: true
        )
    }
    /// Gotham Medium 16px, PrimaryTextColor, Left alignment
    static var settingsCellTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_medium.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 12px, Grey02 color, Left alignment, `lineBreakMode: .byTruncatingTail`
    static var settingsCellDetail = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.grey02,
            textAlignment: .left,
            lineBreakMode: .byTruncatingTail,
            numberOfLines: 1,
            adjustsFontSizeToFitWidth: true
        )
    }
    /// Gotham Bold 16px, Primary color, Left alignment
    static var applianceDetailLeadingLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16, weight: .bold),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    /// Gotham Book 16px, Primary color, Right alignment
    static var applianceDetailTrailingLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textAlignment: .right,
            adjustsFontSizeToFitWidth: true
        )
    }
    
    // MARK: Cooking Charts
    
    static var cookingChartSubtitleLabel = LabelStyle { theme in
      LabelStyleProperties(
          font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 12),
          textColor: theme.grey02,
          textAlignment: .left
      )
    }

    static var cookingChartHeaderLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryAccentColor,
            textAlignment: .left
        )
    }
    static var cookingChartTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.primaryTextColor,
            textAlignment: .left
        )
    }
    static var cookingChartSubitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.tertiaryTextColor,
            textAlignment: .left,
            numberOfLines: 0
        )
    }
    static var cookingChartItemTitleLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryAccentColor,
            textAlignment: .left
        )
    }
    static var cookingChartItemDetailLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.primaryTextColor,
            textAlignment: .left,
            numberOfLines: 0
        )
    }
    static var cookingChartCellHeaderLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryAccentColor,
            textAlignment: .left
        )
    }
    
    static var cookingChartsRecipeListTimeLabel = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 10) ?? .systemFont(ofSize: 10),
            textColor: theme.grey01
        )
    }
    
    static var exploreWoodFireBannerTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 24) ?? .systemFont(ofSize: 24),
            textColor: theme.white01
        )
    }
    
    static var exploreWoodFireBannerSubtitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textColor: theme.white01
        )
    }
    
    static var exploreFilterCollectionViewTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.primaryTextColor
        )
    }
    
    static var exploreFilterCollectionViewTitleWithAlternateColor = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.white01
        )
    }
    
    static var exploreFilterCollectionViewCellClearAllFilters = LabelStyle { theme in // 400, 555555
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 14) ?? .systemFont(ofSize: 14),
            textColor: theme.primaryTextColor
        )
    }
    
    static var exploreHeaderTitle = LabelStyle { theme in
      LabelStyleProperties(
          font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
          textColor: theme.primaryTextColor,
          textAlignment: .left
      )
    }
    
    static var exploreHomeGridTitle = LabelStyle { theme in
        LabelStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 12) ?? .systemFont(ofSize: 12),
            textColor: theme.secondaryTextColor,
            textAlignment: .left,
            numberOfLines: 0
        )
    }
}
