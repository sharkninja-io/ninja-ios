//
//  ApplianceItems.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

extension SettingsViewItem {
    static let applianceItems: [SettingsViewItem] = [
        // Detail
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Appliance Detail",
                         icon: IconAssetLibrary.ico_grill.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(ApplianceDetailViewController(), animated: true) }),
        // Warranty
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Warranty Information",
                         icon: IconAssetLibrary.ico_book.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(WarrantyInfoViewController(), animated: true) }),
        // Support
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Support",
                         icon: IconAssetLibrary.ico_chat_bubble.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(SupportViewController(), animated: true) })
    ]
}
