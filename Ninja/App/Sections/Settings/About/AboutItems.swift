//
//  AboutItems.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

extension SettingsViewItem {
    static let aboutItems: [SettingsViewItem] = [
//        SettingsViewItem(itemStyle: .navigationLink,
//                         title: "Data Protection",
//                         icon: IconAssetLibrary.ico_person_checkmark.asImage() ?? UIImage(),
//                         onNavigate: { _ in return }), // navigation in navigation?.pushViewController(DataProtectionViewController(), animated: true) }),
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Terms of Use",
                         icon: IconAssetLibrary.ico_page.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(TermsOfUseViewController(), animated: true) }),
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Privacy Policy",
                         icon: IconAssetLibrary.ico_page.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(PrivacyPolicyViewController(), animated: true) }),
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Information / Legal Notice",
                         icon: IconAssetLibrary.ico_page_flip.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(LegalNoticeViewController(), animated: true) }),
    ]
}
