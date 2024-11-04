//
//  SceneDelegate.swift
//  Ninja
//
//  Created by Martin Burch on 8/18/22.
//

import UIKit
import Bugsnag

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = scene as? UIWindowScene
        // DISABLE DARK MODE
        window?.overrideUserInterfaceStyle = .light
        
        if let userActivity = connectionOptions.userActivities.first, userActivity.activityType == NSUserActivityTypeBrowsingWeb, let appLinkURL = userActivity.webpageURL {
            handleUniversalLink(appLinkURL, coldLaunch: true)
        } else {
            loadSplashScreen()
        }
    }
    
    internal func loadSplashScreen() {
        let splashScreen = SplashViewController()
        splashScreen.animationCompletion = { [weak self] in
            self?.checkUserSession()
        }
        window?.rootViewController = UINavigationController(rootViewController: splashScreen)
        window?.makeKeyAndVisible()
    }
    
    internal func checkUserSession() {
        if !AuthenticationViewModel.shared().isLoggedIn() {
            self.isLoggedOut()
        } else {
            isLoggedIn()
        }
    }
    
    internal func isLoggedIn() {
        // Set Bugsnag Id to Ayla UUID
//        if let userId = AuthenticationViewModel.shared().getUserId() {
//            Bugsnag.setUser(userId, withEmail: nil, andName: nil)
//        }
        // Avoid unusual cases of profile not being present despite user being signed in
        Task {
            try await IntershopAccountService().signIn()
        }

        NavigationManager.shared.toMainMenu(window: window)
    }
    
    internal func isLoggedOut() {
        NavigationManager.shared.toAuthentication(window: window)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        NavigationBarStyling.styleNavBar()
        TabBarStyling.styleTabBar()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let appLinkURL = userActivity.webpageURL else { return }
        handleUniversalLink(appLinkURL, coldLaunch: false)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let appLinkURL = URLContexts.first?.url else { return }
        handleUniversalLink(appLinkURL, coldLaunch: false)
    }
    
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        guard let appLinkURL = stateRestorationActivity.webpageURL else { return }
        handleUniversalLink(appLinkURL, coldLaunch: false)
    }
    
    private func handleUniversalLink(_ url: URL, coldLaunch: Bool) {
        let linkHandler = UniversalLinkManager(redirectUri: url, coldLaunch: coldLaunch)
        linkHandler.redirect(window)
    }
}
