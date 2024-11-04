//
//  AppDelegate.swift
//  Ninja
//
//  Created by Martin Burch on 8/18/22.
//

import UIKit
import Bugsnag
import GrillCore
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: APP FUNCTIONS
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
        
        setupBugsnag()
        MixpanelService.configure()
        TestFairyService.shared.startSession()
        GrillCoreSDK.setup()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setupBugsnag() {
        // Crash reporting service...
        let config = BugsnagConfiguration.loadConfig()
        config.enabledErrorTypes.cppExceptions = true
        config.enabledErrorTypes.machExceptions = true
        config.enabledErrorTypes.ooms = true
        config.enabledErrorTypes.signals = true
        config.enabledErrorTypes.unhandledExceptions = true
        #if DEBUG
            config.releaseStage = "development"
        #else
            config.releaseStage = "production"
        #endif
        Bugsnag.start(with: config)
    }
    
    func leaveReview() {
        // TODO: //
    }
}

// MARK: NOTIFICATIONS
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // token received - associate with GrillCore etc.
        Task {
            await NotificationService.shared.registerTokenWithGrillCore(deviceToken: deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // no token - log error
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //
        completionHandler([.list, .sound, .badge])
    }
    
}
