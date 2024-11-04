//
//  MenuTabBarItems.swift
//  Ninja
//
//  Created by Martin Burch on 8/21/22.
//

import UIKit

class MenuTabBarItems {
    static let viewControllers: [UIViewController] = {

        let explore = ExploreHomeViewController()
        explore.tabBarItem = UITabBarItem(title: "Charts", image: IconAssetLibrary.ico_timer.asImage(), selectedImage: IconAssetLibrary.ico_timer.asImage())
        let cook = PreCookViewController()
        cook.tabBarItem = UITabBarItem(title: "Cook", image: IconAssetLibrary.ico_bbq.asImage(), selectedImage: IconAssetLibrary.ico_bbq.asImage())
        let settings = SettingsLandingViewController()
        settings.tabBarItem = UITabBarItem(title: "Settings", image: IconAssetLibrary.ico_cog.asImage(), selectedImage: IconAssetLibrary.ico_cog.asImage())
        
        return [explore, cook, settings]
    }()
}
