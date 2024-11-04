//
//  NotificationService.swift
//  Ninja
//
//  Created by Martin Burch on 4/10/23.
//

import Foundation
import NotificationCenter
import Combine
import GrillCore

typealias NotificationManager = GrillCoreSDK.NotificationManager

class NotificationService {
    private var disposables: Set<AnyCancellable> = []
    
    public var allSubscribedSubject = CurrentValueSubject<Bool, Never>(false)
    public var allDsns: [String] = [] {
        didSet {
            updateAllSubscribed(dsns: allDsns)
        }
    }
    public var userReceivesCookingNotifications: Bool {
        get { CacheService.shared().getUserReceivesCookingNotifications() }
        set { CacheService.shared().setUserReceivesCookingNotifications(newValue) }
    }
    public var tokenRegisteredSubject = CurrentValueSubject<Bool, Never>(false)
    public var workingSubject = CurrentValueSubject<Bool, Never>(false)
    
    public static var shared: NotificationService = .init()
    
    private init() { }
    
    // MARK: IOS PUSH
    @discardableResult
    @MainActor
    public func initNotifications() async -> Bool {
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                if success {
                    Logger.Debug("NOTIFICATIONS: INITIALIZED")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    continuation.resume(returning: true)
                } else {
                    Logger.Debug("NOTIFICATIONS: ERROR FAILED INITIALIZION")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    public func isRegistered() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    public func registerTokenWithGrillCore(deviceToken: Data) async -> Bool {
        let oldToken = CacheService.shared().getAppPushNotificationHexKey()
        let newToken = deviceToken.hex
        if oldToken != newToken {
            CacheService.shared().setAppPushNotificationHexKey(deviceToken)
            Logger.Debug("NOTIFICATIONS: APNS Token Changed: \(deviceToken.hex)")
            let result = await NotificationManager.updatePushToken()
            
            return await withCheckedContinuation({ continuation in
                result.onSuccess { _ in
                    continuation.resume(returning: true)
                    tokenRegisteredSubject.send(true)
                    Logger.Debug("NOTIFICATIONS: REGISTERED")
                }.onFailure { error in
                    continuation.resume(returning: false)
                    tokenRegisteredSubject.send(false)
                    Logger.Debug("NOTIFICATIONS: REGISTRATION FAILED")
                }
                updateAllSubscribed(dsns: allDsns)
            })
        } else {
            Logger.Debug("NOTIFICATIONS: APNS Token: \(oldToken)")
            tokenRegisteredSubject.send(true)
            updateAllSubscribed(dsns: allDsns)
            Logger.Debug("NOTIFICATIONS: REGISTERED")
            return true
        }
    }
    
    public func getAuthorizationStatus() async -> UNAuthorizationStatus {
        return await withCheckedContinuation({ continuation in
            UNUserNotificationCenter.current().getNotificationSettings { status in
                continuation.resume(returning: status.authorizationStatus)
            }
        })
    }
    
    public func isAuthorized() async -> Bool {
        return await withCheckedContinuation({ continuation in
            UNUserNotificationCenter.current().getNotificationSettings { status in
                switch status.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    continuation.resume(returning: true)
                case .denied, .notDetermined:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
        })
    }
    
    // MARK: GRILLCORE PUSH
    public func initAndSubscribeAll() {
        var registerAttempts = 0
        tokenRegisteredSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] registered in
            guard let self = self else { return }
            if registered {
                Task {
                    self.workingSubject.send(true)
                    Logger.Debug("NOTIFICATIONS: SUBSCRIBE")
                    await self.subscribeAll(dsns: self.allDsns)
                    Logger.Debug("NOTIFICATIONS: SUBSCRIBE DONE")
                    self.workingSubject.send(false)
                    self.disposables.removeAll()
                }
            } else if registerAttempts < 5 {
                Logger.Debug("NOTIFICATIONS: NOT REGISTERED")
                Task {
                    self.workingSubject.send(true)
                    if await self.initNotifications() {
                        Logger.Debug("NOTIFICATIONS: NOW REGISTERED")
                    } else {
                        Logger.Debug("NOTIFICATIONS: ERROR - SUBSCRIPTION FAILED")
                        self.allSubscribedSubject.send(false)
                        self.disposables.removeAll()
                    }
                    self.workingSubject.send(false)
                }
                registerAttempts += 1
            } else {
                Logger.Debug("NOTIFICATIONS: ERROR - TOO MANY ATTEMPTS")
                self.allSubscribedSubject.send(false)
                self.disposables.removeAll()
            }
        }.store(in: &disposables)
    }
    
    public func unsubscribeAll(shouldCache: Bool = true) async {
        self.workingSubject.send(true)
        await unsubscribeAll(dsns: allDsns, shouldCache: shouldCache)
        self.workingSubject.send(false)
    }
    
    public func anySubscribed() -> Bool {
        return allDsns.first(where: { isSubscribed(dsn: $0) }) != nil
    }
    
    // MARK: PRIVATE
    private func updateAllSubscribed(dsns: [String]) {
        allSubscribedSubject.send(tokenRegisteredSubject.value && areSubscribed(dsns: dsns))
    }
    
    private func areSubscribed(dsns: [String]) -> Bool {
        return dsns.allSatisfy { dsn in
            isSubscribed(dsn: dsn)
        }
    }
    
    private func isSubscribed(dsn: String) -> Bool {
        let subscribed = NotificationManager.isSubscribedToCookingNotifications(dsn: dsn)
        return subscribed
    }
    
    private func subscribeAll(dsns: [String]) async {
        Logger.Debug("NOTIFICATIONS: Subscribe all")
        for dsn in dsns {
            await subscribe(dsn: dsn)
        }
        updateAllSubscribed(dsns: dsns)
        userReceivesCookingNotifications = areSubscribed(dsns: dsns)
    }
    
    private func unsubscribeAll(dsns: [String], shouldCache: Bool) async {
        Logger.Debug("NOTIFICATIONS: Unsubscribe all \(shouldCache)")
        for dsn in dsns {
            await unsubscribe(dsn: dsn)
        }
        updateAllSubscribed(dsns: dsns)
        if shouldCache {
            userReceivesCookingNotifications = areSubscribed(dsns: dsns)
        }
    }
    
    @discardableResult
    private func subscribe(dsn: String) async -> Bool {
        Logger.Debug("NOTIFICATIONS: Subscribe DSN: \(dsn)")
        let result = await NotificationManager.subscribeToCookingNotifications(dsn: dsn)
        
        return await withCheckedContinuation({ continuation in
            result.onSuccess { _ in
                Logger.Debug("NOTIFICATIONS: SUBSCRIBE SUCCESS \(dsn)")
                continuation.resume(returning: true)
            }.onFailure { error in
                Logger.Error("NOTIFICATIONS: SUBSCRIBE ERROR \(dsn) \(error)")
                continuation.resume(returning: false)
            }
        })
    }
    
    @discardableResult
    private func unsubscribe(dsn: String) async -> Bool {
        Logger.Debug("NOTIFICATIONS: Unsubscribe DSN: \(dsn)")
        let result = await NotificationManager.unsubscribeFromCookingNotifications(dsn: dsn)
        
        return await withCheckedContinuation({ continuation in
            result.onSuccess { _ in
                Logger.Debug("NOTIFICATIONS: UNSUBSCRIBE SUCCESS \(dsn)")
                continuation.resume(returning: true)
            }.onFailure { error in
                Logger.Error("NOTIFICATIONS: UNSUBSCRIBE ERROR \(dsn) \(error)")
                continuation.resume(returning: false)
            }
        })
    }
}

extension NotificationService {
    
    public func createLocalNotification(title: String, message: String, sound: UNNotificationSound = .default, delay: TimeInterval = 1, info: [AnyHashable: Any] = [:]) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = sound
        content.userInfo = info
        // TODO: -
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                Logger.Error("NOTIFICATION: CREATE ERROR \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
}
