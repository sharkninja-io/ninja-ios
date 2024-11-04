//
//  TabBarStyling.swift
//  Ninja
//
//  Created by Martin Burch on 11/1/22.
//

import UIKit

class TabBarStyling {
    
    static func styleTabBar(tabBar: UITabBar = UITabBar.appearance()) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        //tabBarAppearance.shadowColor = .clear
        if tabBar.bounds.width > 0 {
            tabBarAppearance.shadowImage =
            UIImage.fromLinearGradient(
                size: CGSize(width: tabBar.bounds.width, height: 3),
                colors: [
                    ColorThemeManager.shared.theme.primaryBackgroundColor.cgColor,
                    ColorThemeManager.shared.theme.secondaryBackgroundColor.cgColor,
                ],
                points: [0, 1]
            )
        }
        //tabBarAppearance.backgroundImage = ImageAssetLibrary.img_ninja_logo.asImage()?.tint(color: .red)
        
        // Selected Item background
        //tabBar.tintColor = ColorThemeManager.shared.theme.primaryAccentColor
        tabBar.selectionIndicatorImage = domedRectangle(
            size: CGSize(
                width: tabBar.bounds.width / CGFloat(MenuTabBarItems.viewControllers.count),
                height: tabBar.bounds.height + 38),
            color: ColorThemeManager.shared.theme.primaryBackgroundColor,
            highlightColor: ColorThemeManager.shared.theme.primaryAccentColor,
            domeHeight: 12,
            shadowHeight: 2,
            shadowColor: ColorThemeManager.shared.theme.secondaryBackgroundColor,
            blurHeight: 5
        )
        
        // Items
        //tabBarAppearance.stackedItemWidth = 100
        //tabBarAppearance.stackedItemSpacing = 10
        tabBarAppearance.stackedItemPositioning = .fill
        
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: ColorThemeManager.shared.theme.grey02,
            .font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12)
        ]
//        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: .zero, vertical: 8)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = ColorThemeManager.shared.theme.grey02
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: ColorThemeManager.shared.theme.primaryAccentColor,
            .font: FontFamilyLibrary.gotham_bold.asFont(size: 12) ?? .systemFont(ofSize: 12)
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        // Set
        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    static func domedRectangle(
        size: CGSize,
        color: UIColor,
        highlightColor: UIColor,
        domeHeight: CGFloat,
        domeSide: UIRectEdge = .top,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        blurHeight: CGFloat
    ) -> UIImage {
        return UIGraphicsImageRenderer(
            size: CGSize(
                width: size.width,
                height: size.height
            )
        ).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.addEllipse(
                in: CGRect(
                    origin: CGPoint(x: 0, y: shadowHeight + blurHeight),
                    size: CGSize(width: size.width, height: size.height + domeHeight)
                )
            )
            context.cgContext.addRect(CGRect(
                origin: CGPoint(x: 0, y: domeHeight + shadowHeight + blurHeight),
                size: size))
            context.cgContext.setShadow(
                offset: CGSize(width: 0, height: -shadowHeight),
                blur: blurHeight,
                color: shadowColor.cgColor)
            context.cgContext.drawPath(using: .fill)
            context.cgContext.addEllipse(in: CGRect(
                origin: CGPoint(x: (size.width - 48) / 2, y: shadowHeight + blurHeight + domeHeight), size: CGSize(width: 48, height: 48)
            ))
            context.cgContext.setFillColor(highlightColor.cgColor)
            context.cgContext.drawPath(using: .fill)
        }
    }
}
