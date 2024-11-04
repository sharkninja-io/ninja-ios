//
//  NavigationBarStyling.swift
//  Ninja
//
//  Created by Martin Burch on 11/1/22.
//

import UIKit

class NavigationBarStyling {
    
    static func styleNavBar(navigationBar: UINavigationBar = UINavigationBar.appearance(), showBackgroundImage: Bool = true) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        if showBackgroundImage {
            navBarAppearance.backgroundImage = ImageAssetLibrary.img_ninja_logo.asImage()?
                .tint(color: ColorThemeManager.shared.theme.primaryForegroundColor)
        }
        navBarAppearance.backgroundImageContentMode = .bottom
        //navBarAppearance.shadowColor = ColorThemeManager.shared.theme.primaryAccentColor
        navBarAppearance.shadowImage = ColorThemeManager.shared.theme.primaryBackgroundColor.toImage(size: CGSize(width: 1, height: 8))
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: ColorThemeManager.shared.theme.primaryTextColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ColorThemeManager.shared.theme.primaryTextColor]
        
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: ColorThemeManager.shared.theme.primaryTextColor]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: ColorThemeManager.shared.theme.primaryDisabledForegroundColor]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: ColorThemeManager.shared.theme.primaryAccentColor]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: ColorThemeManager.shared.theme.primaryTextColor]
        
        navBarAppearance.buttonAppearance = barButtonItemAppearance
        navBarAppearance.backButtonAppearance = barButtonItemAppearance
        navBarAppearance.doneButtonAppearance = barButtonItemAppearance

        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.tintColor = ColorThemeManager.shared.theme.primaryTextColor
        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = navBarAppearance
        }
    }
    
    /// A shared `UIBarButtonItem` to be used as the back button for any `BaseViewController` that needs it.
    ///
    /// By default, the button will pop the viewController. This behavior can customized by overriding `.backButtonBehavior()`
    static private var customBackButton = UIBarButtonItem(image: IconAssetLibrary.ico_back_button.asImage())
    static private var customExitButton = UIBarButtonItem(image: IconAssetLibrary.system_xmark.asSystemImage()?.resize(multiplier: 0.85))
    

    /// Connect the shared `customBackButton` to the viewController. Should be called upon `.viewDidLoad()`
    static func setupBackButton(navigationItem : UINavigationItem, target: AnyObject?, action: Selector) {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = NavigationBarStyling.customBackButton
        
        NavigationBarStyling.customBackButton.target = target
        NavigationBarStyling.customBackButton.action = action
    }
    
    static func setupExitButton(navigationItem : UINavigationItem, target: AnyObject?, action: Selector) {
        navigationItem.rightBarButtonItem = NavigationBarStyling.customExitButton
        NavigationBarStyling.customExitButton.target = target
        NavigationBarStyling.customExitButton.action = action
    }
    
    /// Remove the `leftBarButtonItem` and set the shared button's target and action to `nil`
    ///
    /// This guarantees the button has no strong references to the old viewController and prevents issues with a shared object being on two separate viewControllers
    static func removeBackButton(navigationItem: UINavigationItem) {
        navigationItem.leftBarButtonItem = nil
        NavigationBarStyling.customBackButton.target = nil
        NavigationBarStyling.customBackButton.action = nil
    }
    
}
