//
//  MixPanelService.swift
//  SharkClean
//
//  Created by Rick Jacobson on 7/13/22.
//

import Foundation
import Mixpanel


struct MixpanelService {
    
    enum EventSection: String {
        case ScreenView = "Screen_View"
        case DebugEvent = "Debug_Event"
        
        case General
        case Menu
        case AppLaunch = "App_Launch"
        case Auth
        case Education
        case Pairing
        case Setup
        case ExploreRun = "Explore_Run"
        case Maps
        case CarpetVerification = "Carpet_Verification"
        case Dashboard
        case Settings
        case Support
        case History
        case Schedule
    }
    
    /// Get Mixpanel API key from plist
    private static func getApiKey() -> String? {
        var mixpanelApiKey : String?
        if let plistKey = Bundle.main.object(forInfoDictionaryKey: "mixpanel") as? Dictionary<String,AnyObject> {
            mixpanelApiKey = plistKey["apiKey"] as? String
        }
        return mixpanelApiKey
    }
    
    /// Initialize Mixpanel with API Key from target's plist
    public static func configure() {
        if let token = getApiKey() {
            Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        } else {
            Logger.Error("Failed to find Mixpanel API Key")
        }
    }
    
    /// Shared instance of MixpanelService
    public static let shared = MixpanelService()
    
    /// Main Instance of Mixpanel
    private let service = Mixpanel.mainInstance()
    
    // MARK: - Track
    /**
     Log an event with optional associated properties.
     
     If the event was previously called with `.startTimingEvent()`, the time elapsed since then will be included as a property.
     */
    private func trackEvent(_ event: String, properties: [String: MixpanelType]? = nil) {
        service.track(event: event, properties: properties)
    }
    
    /**
     Start a timer for a specific event.
     
     To finish timer, call the same event in `.trackEvent()`
     
     To cancel timer, user `.stopTimingEvent(event: )` or `.stopAllTimedEvents()`
     */
    public func startTimingEvent(_ event: String) {
        service.time(event: event)
    }
    
    /// Stop a previously started timer for a specific event.
    public func stopTimingEvent(_ event: String) {
        service.clearTimedEvent(event: event)
    }
    
    /// Stop all previously started timers for events.
    public func stopAllTimedEvents() {
        service.clearTimedEvents()
    }
    
    // MARK: - User
    /**
     Identify a user by a specific ID.
     
     Required to assign specific properties to the user.
     */
    public func identify(uniqueId: String) {
        service.identify(distinctId: uniqueId)
    }
    
    /**
     Assign a property that will be included with all tracking events sent for this user. Requires having used `identify()` to identify the user, first.
     
     These properties are not dependent on the instance, and will be sent with the user if they are identified on any other devices, as well.
     */
    public func assignUserProperties(property: String, value: MixpanelType) {
        service.people.set(property: property, to: value)
    }
    
    /**
     Assign properties that will be included with all tracking events sent for this user. Requires having used `identify()` to identify the user, first.
     
     These properties are not dependent on the instance, and will be sent with the user if they are identified on any other devices, as well.
     */
    public func assignUserProperties(properties: [String: MixpanelType]) {
        service.people.set(properties: properties)
    }
    
    /**
     Increment the numeric value of a user property.
     
     Must be used on properties that store doubles.
     */
    public func incrementUserProperties(property: String, by amount: Double) {
        service.people.increment(property: property, by: amount)
    }
    
    /**
     Increment the numeric values of an array of user properties.
     
     Must be used on properties that store doubles.
     */
    public func incrementUserProperties(properties: [String: Double]) {
        service.people.increment(properties: properties)
    }
    
    
    // MARK: - Super Properties
    /// Assign properties that will be included with all tracking events sent by this instance.
    public func assignPersistentProperties(properties: [String: MixpanelType]) {
        service.registerSuperProperties(properties)
    }
    
    /// Get a list of properties that will be sent with every event tracked by this instance.
    public func getCurrentPersistentProperties() -> [String: Any] {
        return service.currentSuperProperties()
    }
    
    /// Clear a particular persistent property currently assigned to this instance.
    public func clearPersistentProperty(propertyName: String) {
        service.unregisterSuperProperty(propertyName)
    }
    
    /// Clear all persisnt properties currently assigned to this instance.
    public func clearPersistentProperties() {
        service.clearSuperProperties()
    }
    
    // MARK: - Groups
    ///Set the User to be assigned to a single group.
    public func setUserGroup(groupKey: String, groupID: String) {
        service.setGroup(groupKey: groupKey, groupID: groupID)
    }
    
    /// Set the User to be assigned to multiple groups.
    public func setUserGroup(groupKey: String, groupIDs: [String]) {
        service.setGroup(groupKey: groupKey, groupIDs: groupIDs)
    }
    
    /// Add User to an additional group.
    public func addUserToGroup(groupKey: String, groupID: String) {
        service.addGroup(groupKey: groupKey, groupID: groupID)
    }
    
    /// Remove User from a particular group.
    public func removeUserFromGroup(groupKey: String, groupID: String) {
        service.removeGroup(groupKey: groupKey, groupID: groupID)
    }
    
    /// Delete a group entirely from Mixpanel.
    public func deleteGroup(groupKey: String, groupID: String) {
        service.getGroup(groupKey: groupKey, groupID: groupID).deleteGroup()
    }
    
    /// Assign a property that will be included with all tracking events sent for this group.
    public func assignGroupProperties(groupKey: String, groupID: String, property: String, value: MixpanelType) {
        service.getGroup(groupKey: groupKey, groupID: groupID).set(property: property, to: value)
    }
    
    /// Assign properties that will be included with all tracking events sent for this group.
    public func assignGroupProperties(groupKey: String, groupID: String, properties: [String: MixpanelType]) {
        service.getGroup(groupKey: groupKey, groupID: groupID).set(properties: properties)
    }
    
    /// Remove a property currently assigned to a group.
    public func removeGroupProperty(groupKey: String, groupID: String, property: String) {
        service.getGroup(groupKey: groupKey, groupID: groupID).unset(property: property)
    }
    
    
    // MARK: - Opt Out
    /**
     Resume tracking events.
     
     Tracking is on by default. This only needs to be called if the user has previously opted out.
     */
    public func optInTracking() {
        service.optInTracking()
        // TODO: // CacheService.shared().setMixpanelAnalyticsTracking(true)
    }
    
    /// Stops the instance from sending any tracking events to the backend until directed otherwise
    public func optOutTracking() {
        service.optOutTracking()
        // TODO: // CacheService.shared().setMixpanelAnalyticsTracking(false)
    }
}


extension MixpanelService {
    
    /// Track the appearance of a screen for Mixpanel
    /// - Parameter screen: String describing the name of the screen.
    public func trackScreenAppearance(_ screen: String) {
        trackEvent("\(EventSection.ScreenView):\(screen)", properties: ["Screen": screen])
    }
    
    /**
     Convenience function to track an event from a section of the application.
     
     If the event was previously called with `.startTimingEvent()`, the time elapsed since then will be included as a property.
     - Parameters:
     - section: App Section in which the event has occurred.
     - event:  **Brief** description of the Event
     - properties: Optional additional details for the event.
     */
    public func trackSectionEvent(_ section: EventSection, event: String?, properties: [String: MixpanelType]? = nil) {
        var trackString: String
        if let event = event {
            trackString = "\(section):\(event)"
        } else {
            trackString = section.rawValue
        }
        trackEvent(trackString, properties: properties)
    }
    
    /**
     Convenience function track an error event from a section of the application.
     - Parameters:
     - section: App Section in which the event occurred
     - err: Full desciption of the error
     - properties: Optional additional details for the event.
     */
    public func trackSectionError(_ section: EventSection, event: String, errorDescription err: String, properties: [String: MixpanelType]? = nil) {
        var props: [String: MixpanelType] = [:]
        
        if let properties = properties {
            props = properties
        }
        
        props["Error_Description"] = err
        
        trackEvent("[ERROR]:\(section):\(event)", properties: properties)
    }
}
