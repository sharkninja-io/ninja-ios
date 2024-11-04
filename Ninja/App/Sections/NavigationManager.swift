//
//  NavigationManager.swift
//  Ninja
//
//  Created by Martin Burch on 12/15/22.
//

import UIKit

class NavigationManager {
    
    var partTransitioningDelegate: PartialPresentationControllerDelegate? = nil
    let bleDeniedId = "BLE_DENIED_ID"
    
    
    private static let _instance: NavigationManager = .init()
    static var shared: NavigationManager {
        return _instance
    }
    
    func toAuthentication(window: UIWindow?) {
        if AuthenticationViewModel.shared().isCountryCached() {
            window?.rootViewController = UINavigationController(rootViewController: LoginFormViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: CountryRegionViewController())
        }
        window?.makeKeyAndVisible()
    }
    
    func toWifiPairing(viewController: UIViewController) {
        let vc = UINavigationController(rootViewController: PairingSplashViewController())
        vc.modalPresentationStyle = .custom
        partTransitioningDelegate = PartialPresentationControllerDelegate(heightPercent: 1)
        vc.transitioningDelegate = partTransitioningDelegate
        viewController.present(vc, animated: true)
    }
    
    func toBTPairing(viewController: UIViewController, animate: Bool = true) {
        let vc = UINavigationController(rootViewController: BTPermissionsViewController())
        vc.modalPresentationStyle = .custom
        partTransitioningDelegate = PartialPresentationControllerDelegate(heightPercent: 1)
        vc.transitioningDelegate = partTransitioningDelegate
        viewController.present(vc, animated: animate)
    }
    
    func toMainMenu(window: UIWindow?) {
        window?.rootViewController = MenuTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func toVerifyAccount(_ window: UIWindow?, coldLaunch: Bool = false) {
        let navController = UINavigationController(rootViewController: coldLaunch ? LoginFormViewController() : CreateVerifyingViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func toResetPassword(_ window: UIWindow?) {
        window?.rootViewController = UINavigationController(rootViewController: ResetPasswordViewController())
        window?.makeKeyAndVisible()
    }

    func setBLEDenied(denied: Bool) {
        UserDefaults.standard.set(denied, forKey: bleDeniedId)
        Logger.Debug("DENIED BLE REDIRECT: \(denied)")
    }
    
    func isBLEDenied() -> Bool {
        return UserDefaults.standard.bool(forKey: bleDeniedId)
    }
}
