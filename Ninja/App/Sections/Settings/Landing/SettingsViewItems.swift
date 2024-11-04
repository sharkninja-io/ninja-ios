//
//  SettingsViewItems.swift
//  Ninja
//
//  Created by Martin Burch on 9/26/22.
//

import UIKit

class SettingsViewItem {
    enum ItemStyle {
        case navigationLink
        case toggle
        case none
    }

    let itemStyle: ItemStyle
    let title: String
    let description: String?
    let icon: UIImage
    let iconTint: UIColor
    var onNavigate: ((UINavigationController?) -> ())?
    
    init(itemStyle: ItemStyle, title: String, description: String? = nil, icon: UIImage, iconTint: UIColor = ColorThemeManager.shared.theme.primaryAccentColor, onNavigate: ( (UINavigationController?) -> Void)? = nil) {
        self.itemStyle = itemStyle
        self.title = title
        self.description = description
        self.icon = icon
        self.iconTint = iconTint
        self.onNavigate = onNavigate
    }
}

extension SettingsViewItem {
    static let landingItems: [SettingsViewItem] = [
        // Profile
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Account",
                         description: "Profile, Change Email, Log Out...",
                         icon: IconAssetLibrary.ico_person.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(AccountLandingViewController(), animated: true) }),
        // Appliance
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Your Appliance",
                         description: "Appliance Detail, Warranty Information, Support...",
                         icon: IconAssetLibrary.ico_grill.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(ApplianceLandingViewController(), animated: true) }),
        // About
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "About This App",
                         description: "Data Protections, Terms of Use, Privacy Policy...",
                         icon: IconAssetLibrary.ico_smartphone.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(AboutViewController(), animated: true) }),
        // Cooking Notifications
        SettingsViewItem(itemStyle: .toggle,
                         title: "Cooking Notifications (push)",
                         icon: IconAssetLibrary.ico_bell_notification.asImage() ?? UIImage()),
    ]
}
