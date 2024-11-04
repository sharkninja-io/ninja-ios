//
//  SettingsViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 9/26/22.
//

import Foundation
import Combine
import UIKit
import GrillCore

final class SettingsViewModel {
    
    var disposables = Set<AnyCancellable>()
    
    // MARK: Services
    private lazy var settingsService: SettingsService = .shared()
    private lazy var authService: AuthenticationService = .shared()
    private lazy var deviceService: DeviceControlService = .shared
    private lazy var notificationService: NotificationService = .shared
    
    // MARK: User Properties    
    public var email: String {
        get {
            guard let cachedEmail = GrillCoreSDK.User.getUsername().unwrapOrNil() else {
                return .emptyOrNone
            }
            return cachedEmail
        }
    }
        
    // Subjects
    public var accountDeletedSubject = PassthroughSubject<Bool, Never>()
    public var changeEmailSubject = PassthroughSubject<Bool, Never>()
    public var changePasswordSubject = PassthroughSubject<Bool, Never>()
    public var factoryResetSubject = PassthroughSubject<Bool, Never>()
    public var applianceDeletedSubject = PassthroughSubject<Bool, Never>()
    public var notificationsEnabledSubject: CurrentValueSubject<Bool, Never> {
        get { notificationService.allSubscribedSubject }
    }
    public var notificationsWorkingSubject: CurrentValueSubject<Bool, Never> {
        get { notificationService.workingSubject }
    }
    
    // MARK: - Profile Properties
    // Computed Properties
    public var country: Country { return Country.current }
    public var server: CountryRegionSupport.CountryRegionServer { return CacheService.shared().getSelectedCountryServerForUser() }
    public var usesFDM4: Bool = false // { return self.server == .NorthAmerica } TODO: Delete when certain
    
    // Profile Registration
    public var userProfile: IntershopCustomerApi.Customer?
    public var userProfileDraft: IntershopCustomerApi.Customer? {
        didSet {
            profileChangesSubject.send(userProfile != userProfileDraft)
        }
    }
    
    // Subjects
    public var profileChangesSubject = PassthroughSubject<Bool, Never>()
    public var profileSaveSubject = PassthroughSubject<Bool, Never>()
    
    
    // MARK: - Preferences Properties
    public var weightUnit: SettingsViewModel.WeightUnitPreference = .pounds
    public var temperatureUnit: SettingsViewModel.TemperatureUnitPreference = .fahrenheight
    
    
    // MARK: - Grill Properties
    public var currentGrillSubject: CurrentValueSubject<Grill?, Never> {
        get { deviceService.currentGrillSubject }
    }
    public var grillsSubject: CurrentValueSubject<[GrillCoreSDK.Grill]?, Never> {
        get { return deviceService.grillsSubject }
    }
    public var currentGrillList: [GrillCoreSDK.Grill] = []
    public var currentGrillDetails: GrillCoreSDK.GrillDetails?
    public var currentGrillErrors: [GrillCoreSDK.GrillError] = []
    public var grillNoticiationsEnabled: Bool?
    
    // TODO: Talk about how errors will be handled and presented
    public var genericRequestFailureSubject = PassthroughSubject<Bool, Never>()
    
    
    // MARK: - Singleton
    private static var _instance: SettingsViewModel = .init()
    public static func shared() -> SettingsViewModel { return _instance }
    private init() {
        subscribeToSubjects()
    }
    
    private func subscribeToSubjects() {
        authService.isLoggedInSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] isLoggedIn in
            guard let self else { return }
            if isLoggedIn {
                self.preFetchData()
            } else {
                self.cleanupAfterLogout()
            }
        }.store(in: &disposables)
        
        deviceService.currentGrillSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] currentGrill in
            guard let self, currentGrill != nil else { return }
            self.fetchGrillDetails()
        }.store(in: &disposables)
        
        deviceService.grillsSubject.receive(on: DispatchQueue.global(qos: .background)).sink { [weak self] grills in
            guard let self else { return }
            self.currentGrillList = grills ?? []
        }.store(in: &disposables)
    }
    
    
    // MARK: - Landing
    /// Prefetches all relevant settings. Call any time a significant change to settings or grills/appliances may have been made.
    func preFetchData() {
        Task {
            fetchProfile()
            fetchPreferences()
        }
    }
    
    func setCookingNotifications(enabled: Bool) async {
        if enabled {
            notificationService.initAndSubscribeAll()
        } else {
            _ = await notificationService.unsubscribeAll()
        }
    }
    
    func hasDeniedPushNotifications() async -> Bool {
        return await notificationService.getAuthorizationStatus() == .denied
    }
        
    // MARK: - Account
    // Logout
    func logout() {
        Task {
            let success = await authService.logout()
            
            if success {
                cleanupAfterLogout()
                await notificationService.unsubscribeAll(shouldCache: false)
            }
        }
    }
    
    func forceLogout() {
        authService.isLoggedInSubject.send(false)
    }
    
    private func cleanupAfterLogout() {
        userProfile = nil
        userProfileDraft = nil
    }
    
    
    func changeUserEmail(_ email: String) {
        Task {
            do {
                try await settingsService.updateEmailWithIntershop(newEmail: email)
                self.changeEmailSubject.send(true)
            } catch let error {
                Logger.Error(error)
                MixpanelService.shared.trackSectionError(.Settings, event: "IntershopEmailUpdate", errorDescription: error.localizedDescription)
                self.changeEmailSubject.send(false)
            }
            
        }
    }
    
    func changePassword(old: String, new: String) {
        Task {
            changePasswordSubject.send(await authService.changePassword(password: old, newPassword: new))
        }
    }
    
    func deleteAccount() {
        Task {
            let success = await authService.deleteAccount()
            accountDeletedSubject.send(success)
        }
    }
    
    
    
    // MARK: - Profile
    func fetchProfile() {
        Task {
            do {
                try await IntershopAccountService().signIn()
            } catch let error {
                Logger.Error(error.localizedDescription)
            }
        }
    }
    
    func resetProfileChanges() {
        userProfileDraft = userProfile
    }
    
    func updateProfile() {
        guard let userProfileDraft else { return }
        Task {
            do {
                try await IntershopProfileService().update(profile: userProfileDraft)
                profileSaveSubject.send(true)
            } catch let error {
                Logger.Error("Error updating user profile on Intershop: \(error)")
                MixpanelService.shared.trackSectionError(.Settings, event: "IntershopProfileUpdate", errorDescription: error.localizedDescription)
                profileSaveSubject.send(false)
            }
        }
    }
    
    // MARK: - Preferences
    func fetchPreferences() {
        let weight = CacheService.shared().getWeightUnitPreference()
        weightUnit = WeightUnitPreference(rawValue: weight) ?? .pounds
        let temp = CacheService.shared().getTemperatureUnitPreference()
        temperatureUnit = TemperatureUnitPreference(rawValue: temp) ?? .fahrenheight
    }
            
    func setWeightUnitPreference(_ unit: String) {
        CacheService.shared().setWeightUnitPreference(unit)
        weightUnit = WeightUnitPreference(rawValue: unit) ?? .pounds
    }
    
    func setTemperatureUnitPreference(_ unit: String) {
        CacheService.shared().setTemperatureUnitPreference(unit)
        temperatureUnit = TemperatureUnitPreference(rawValue: unit) ?? .fahrenheight
    }
    
    
    // MARK: - Grills
    func setCurrentGrill(_ grill: Grill) {
        deviceService.setCurrentDevice(grill: grill)
    }
    
    func fetchGrillDetails() {
        guard let grill = currentGrillSubject.value else {
            Logger.Debug("No current grill found.")
            return
        }
        
        Task {
            currentGrillDetails = await settingsService.getGrillDetails(grill)
            currentGrillErrors = await settingsService.getGrillErrorLog(grill)
        }
    }
    
    func toggleGrillNotifications() {
        // TODO: Push Notifications
    }
    
    func restoreFactorySettings() {
        Task {
            let result = await settingsService.resetFactorySettings(currentGrillSubject.value)
            deviceService.getDevices()
            factoryResetSubject.send(result)
        }
    }
    
    func deleteAppliance() {
        Task {
            let result = await settingsService.deleteAppliance(currentGrillSubject.value)
            deviceService.getDevices()
            applianceDeletedSubject.send(result)
        }
    }
    
    func getWarrantyURL() -> URL? {
        return URL(string: "https://support.ninjakitchen.com/hc/en-us/sections/4402881170194-Warranty") ?? nil
    }
    
    
    // MARK: - Support
    func getSupportURL() -> URL? {
        return URL(string: "https://support.ninjakitchen.com/hc/en-us/sections/9185734924060-OG901-Series-") ?? nil
    }
    
    // MARK: - About
    func getTermsAndConditionsURL() -> URL? {
        return URL(string: "https://www.ninjakitchen.com/page/terms-and-conditions") ?? nil
    }
    
    func getPrivacyPolicyURL() -> URL? {
        return URL(string: "https://www.sharkninja.com/privacy-notice-iot/en") ?? nil
    }
}

// MARK: - Enums
extension SettingsViewModel {
    // TODO: Implement this preference globally.
    public enum TemperatureUnitPreference: String, CaseIterable {
        case fahrenheight = "F"
        case celsius = "C"
        
        var withTemperatureSymbol: String { return .temperatureSymbol + self.rawValue }
    }
    
    public enum WeightUnitPreference: String, CaseIterable {
        case pounds = "Pounds (lb)"
        case grams = "Grams (g)"
        case kilograms = "Kilograms (kg)"
        case ounces = "Ounces (oz)"
        
        var localizaedName: String {
            switch self {
            case .pounds:
                return "Pounds (lb)"
            case .grams:
                return "Grams (g)"
            case .kilograms:
                return "Kilograms (kg)"
            case .ounces:
                return "Ounces (oz)"
            }
        }
    }
}
