//
//  ProfileItems.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import Foundation
import UIKit

extension SettingsViewItem {
    static let accountItems: [SettingsViewItem] = [
        // Change Email
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Change Email",
                         icon: IconAssetLibrary.ico_mail.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(ChangeEmailViewController(), animated: true)}),
        // Change Password
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Change Password",
                         icon: IconAssetLibrary.ico_lock.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(ChangePasswordViewController(), animated: true)}),
        // Profile
        SettingsViewItem(itemStyle: .navigationLink,
                         title: "Profile",
                         description: "Name, Address, Phone Number...",
                         icon: IconAssetLibrary.ico_person_circle.asImage() ?? UIImage(),
                         onNavigate: { navigation in navigation?.pushViewController(ProfileViewController(), animated: true) }),
        // Preferences
//        SettingsViewItem(itemStyle: .navigationLink,
//                         title: "Preferences",
//                         description: "Your Appliance, Weight Units, Temperature Units...",
//                         icon: IconAssetLibrary.ico_preference_sliders.asImage() ?? UIImage(),
//                         onNavigate: { navigation in navigation?.pushViewController(PreferencesViewController(), animated: true) }),
        // Log out
        SettingsViewItem(itemStyle: .none,
                         title: "Log Out",
                         icon: IconAssetLibrary.ico_logout.asImage() ?? UIImage(),
                         onNavigate: { navigation in
                             guard let controller = navigation?.topViewController as? AccountLandingViewController else {
                                 Logger.Error("Unexpected viewcontroller type calling for Logout: \(String(describing: navigation?.topViewController))")
                                 return
                             }
                             controller.showLogoutModal()
                         })
    ]
}
