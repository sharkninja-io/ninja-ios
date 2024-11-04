//
//  CacheService+DataStore+Extension.swift
//  SharkClean
//
//  Created by Jonathan on 1/24/22.
//

import Foundation

extension CacheService {
    // USER KEYS
    internal var kAppPushNotifications: String { "push_token" }
    internal var kUserHasSuccessfullyLoggedIn: String { "userHasSuccessfullyLoggedIn" }
    internal var kCookingNotifications: String { "cookingNotifications" }
    internal var kTemperatureUnitPreference: String { "temperatureUnitPreference "}
    internal var kWeightUnitPreference: String { "weightUnitPreference" }
    internal var kAppCurrentUserSession: String { "session" }
    internal var kCountForDeviceUsage: String { "countForDeviceUsage" }
    internal var kDateSinceLastReview: String { "dateSinceLastReview" }
    internal var kLastReviewVersion: String { "lastReviewVersion" }
    internal var kSelectedCountryRegionForUser: String { "countryRegionSelection" }
    internal var kSelectedCountryServerForUser: String { "countryRegionSelectionServer" }
    internal var kMixpanelAnalyticsTracking: String { "mixpanelAnalyticsTracking" }
    internal var kAppCurrentIntershopToken: String { "authentication-token" }
}

extension CacheService {
    
    // MARK: User Sets
    public func setAppPushNotificationHexKey(_ apnsKey: Data) {
        self.set(.App, key: kAppPushNotifications, data: .Str(apnsKey.hex))
    }
    
    public func setUserHasSuccessfullyLoggedIn(_ hasLoggedIn: Bool) {
        self.set(.User, key: kUserHasSuccessfullyLoggedIn, data: .Boolean(hasLoggedIn))
    }
    
    public func setUserIntershopAuthorizationToken(_ interhsopToken: String) {
        self.set(.User, key: kAppCurrentIntershopToken, data: .Str(interhsopToken))
    }
    
    public func setUserReceivesCookingNotifications(_ enabled: Bool) {
        self.set(.User, key: kCookingNotifications, data: .Boolean(enabled))
    }
    
    public func setTemperatureUnitPreference(_ unit: String) {
        self.set(.User, key: kTemperatureUnitPreference, data: .Str(unit))
    }
    
    public func setWeightUnitPreference(_ unit: String) {
        self.set(.User, key: kWeightUnitPreference, data: .Str(unit))
    }
    
    public func incrementCountForDeviceUsage() {
        let count = getCountForDeviceUsage()
        self.set(.User, key: kCountForDeviceUsage, data: .Integer(count + 1))
        Logger.Debug("Device Usage Count: \(count)")
    }
    
    public func setDateForLastReviewRequest() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatString
        let dateString = formatter.string(from: date)
        Logger.Debug("Date Since Last Review: \(dateString)")
        self.set(.User, key: kDateSinceLastReview, data: .Str(dateString))
    }
    
    public func setLastReviewBundleVersion(_ versionString: String) {
        self.set(.User, key: kLastReviewVersion, data: .Str(versionString))
    }
    
    public func setSelectedCountryRegionForUser(_ country: CountryRegionSupport) {
        self.set(.User, key: kSelectedCountryRegionForUser, data: .Str(country.code))
        self.set(.User, key: kSelectedCountryServerForUser, data: .Str(country.server.rawValue))
    }
    
    public func setMixpanelAnalyticsTracking(_ didUserOptedIn: Bool) {
        self.set(.User, key: kMixpanelAnalyticsTracking, data: .Boolean(didUserOptedIn))
    }
    
}

extension CacheService {

    // MARK: User Gets
    public func getAppPushNotificationHexKey() -> String {
        let data = self.get(.App, key: kAppPushNotifications)
        let token = data.getString()
        return token
    }

    public func getCountForDeviceUsage() -> Int {
        let data = self.get(.User, key: kCountForDeviceUsage)
        let count = data.getInt()
        return count
    }
    
    public func getDateSinceLastReview() -> Date? {
        let data = self.get(.User, key: kDateSinceLastReview)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatString
        if let formedDate = formatter.date(from: data.getString()) {
            return formedDate
        }
        return nil
    }
    
    public func getLastReviewBundleVersion() -> String? {
        let data = self.get(.User, key: kLastReviewVersion)
        let versionString = data.getString()
        return versionString
    }
    
    public func getUserHasSuccessfullyLoggedIn() -> Bool {
        let data = self.get(.User, key: kUserHasSuccessfullyLoggedIn)
        let previousSuccess = data.getBoolean()
        return previousSuccess
    }
    
    public func getUserIntershopAuthorizationToken() -> String {
        let data = self.get(.User, key: kAppCurrentIntershopToken)
        let token = data.getString()
        return token
    }
    
    public func getUserReceivesCookingNotifications() -> Bool {
        let data = self.get(.User, key: kCookingNotifications)
        let preference = data.getBoolean()
        return preference
    }
    
    public func getTemperatureUnitPreference() -> String {
        let data = self.get(.User, key: kTemperatureUnitPreference)
        let preference = data.getString()
        return preference
    }
    
    public func getWeightUnitPreference() -> String {
        let data = self.get(.User, key: kWeightUnitPreference)
        let preference = data.getString()
        return preference
    }
    
    public func getCurrentAppUserSession() -> [String: Any] {
        let data = self.get(.User, key: kAppCurrentUserSession)
        let sessionDict = data.getDictionary()
        return sessionDict
    }
    
    public func getSelectedCountryRegionForUser() -> String {
        let data = self.get(.User, key: kSelectedCountryRegionForUser)
        let code = data.getString()
        return code
    }
    
    public func getSelectedCountryServerForUser() -> CountryRegionSupport.CountryRegionServer {
        let data = self.get(.User, key: kSelectedCountryServerForUser)
        let code = data.getString()
        let server = CountryRegionSupport.CountryRegionServer(rawValue: code) ?? .NorthAmerica
        return server
    }
    
    public func getMixpanelAnalyticsTracking() -> Bool {
        let data = self.get(.User, key: kMixpanelAnalyticsTracking)
        let optIn = data.getBoolean()
        return optIn
    }
        
}
