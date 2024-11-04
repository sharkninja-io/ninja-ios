//
//  ApplianceDetailItems.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

extension ApplianceDetailViewController {
    internal enum DetailCellField: String, CaseIterable {
        case dsn = "DSN"
        case MacAddress = "Mac Address"
        case AppVersion = "App Version"
        case FirmwareVersion = "Firmware Version"
        
        func getProperty() -> String {
            let vm = SettingsViewModel.shared()
            switch self {
            case .dsn:
                return vm.currentGrillDetails?.dsn ?? "--"
            case .MacAddress:
                return vm.currentGrillDetails?.mac ?? "--"
            case .AppVersion:
                let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Error"
                let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Error"
                return "\(appVersion) (\(buildNumber))"
            case .FirmwareVersion:
                return vm.currentGrillDetails?.otaFirmwareVersion ?? "--"
            }
        }
    }
}

extension SettingsViewItem {
    static let applianceDetailItems: [SettingsViewItem] = [
        // Error Notifications
//        SettingsViewItem(itemStyle: .toggle,
//                         title: "Error Notifications (push)",
//                         icon: IconAssetLibrary.ico_chat_bubble_error.asImage() ?? UIImage()),
        // Error Log
        SettingsViewItem(itemStyle: .none,
                         title: "Appliance Error Log",
                         icon: IconAssetLibrary.ico_exclamation_circle.asImage() ?? UIImage(),
                         iconTint: ColorThemeManager.shared.theme.tertiaryWarmAccentColor,
                         onNavigate: { navigation in navigation?.pushViewController(ApplianceErrorLogViewController(), animated: true) }),
        // TODO: Gone for good?
//        // Factory Reset
//        SettingsViewItem(itemStyle: .none,
//                         title: "Restore Factory Settings",
//                         icon: IconAssetLibrary.ico_restart.asImage() ?? UIImage(),
//                         onNavigate: { navigation in
//                             guard let controller = navigation?.topViewController as? ApplianceDetailViewController else { return }
//                             controller.showFactoryResetModal()
//                         }),
        // Delete Appliance
        SettingsViewItem(itemStyle: .none,
                         title: "Delete Appliance",
                         icon: IconAssetLibrary.ico_trash.asImage() ?? UIImage(),
                         iconTint: ColorThemeManager.shared.theme.primaryErrorForegroundColor,
                         onNavigate: { navigation in
                             guard let controller = navigation?.topViewController as? ApplianceDetailViewController else { return }
                             controller.showDeleteApplianceModal()
                         })
    ]
}
