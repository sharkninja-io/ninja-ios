//
//  MenuTabBarViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 8/22/22.
//

import Combine
import UIKit
import GrillCore

class MenuTabBarViewModel {
    
    private var devicesService: DeviceControlService = .shared
    private lazy var pairingService: DeviceBTPairingService = .shared
    private lazy var notificationService: NotificationService = .shared
    private lazy var reviewRequestService: ReviewRequestService = .shared

    var devicesSubject: CurrentValueSubject<[Grill]?, Never> {
        get { return devicesService.grillsSubject }
    }
    
    var currentStateSubject: CurrentValueSubject<GrillState?, Never> {
        get { return devicesService.currentStateSubject }
    }
    
    var currentGrillSubject: CurrentValueSubject<Grill?, Never> {
        get { return devicesService.currentGrillSubject }
    }
    
    var devicesErrorSubject: PassthroughSubject<CloudCoreSDK.Error, Never> {
        get { return devicesService.errorSubject }
    }
    
    var pairingCompleted: PassthroughSubject<String, Never> {
        get { return pairingService.completedSubject }
    }
    
    private static var _instance: MenuTabBarViewModel = .init()
    
    public static func shared() -> MenuTabBarViewModel {
        return _instance
    }
    
    private init() { }
    
    // MARK: DEVICES
    func loadDevices() {
        Task {
            await devicesService.loadDevices()
        }
    }
    
    func clearDevices() {
        devicesService.clearDevices()
    }
    
    func startMonitoring() {
        devicesService.startMonitoring()
    }
    
    func stopMonitoring() {
        devicesService.stopMonitoring()
    }
    
    // MARK: NOTIFICATIONS
    func subscribeAllToNotifications() {
        notificationService.initAndSubscribeAll()
    }
    
    func unsubscribeAllNotifications() async {
        await notificationService.unsubscribeAll()
    }
    
    func initNotifications() async -> Bool {
        return await notificationService.initNotifications()
    }

    func isAnySubscribed() -> Bool {
        return notificationService.anySubscribed()
    }
    
    func isNotificationTokenRegistered() -> Bool {
        return notificationService.tokenRegisteredSubject.value
    }
    
    func userReceivesCookNotifications() -> Bool {
        return notificationService.userReceivesCookingNotifications
    }
    
    // MARK: REVIEW DIALOG
    func shouldDisplayReviewModal() -> Bool {
        return reviewRequestService.shouldRequestReview()
    }
    
    @MainActor
    func displayReviewRequest(scene: UIWindowScene) {
        reviewRequestService.requestReview(scene: scene)
    }
    
    func setDisplayedReviewModalDate() {
        reviewRequestService.setLastRequestDate()
    }
}
