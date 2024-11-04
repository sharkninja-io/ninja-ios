//
//  ReviewRequestViewController.swift
//  Ninja
//
//  Created by Martin Burch on 8/2/23.
//

import Foundation
import StoreKit

class ReviewRequestService {
    private var cacheService: CacheService = .shared()
    
    private static let minimumSecondsRequestInterval: TimeInterval = 10512000 // third of a year in seconds

    private static var _instance: ReviewRequestService = .init()
    static var shared: ReviewRequestService {
        get { _instance }
    }
    
    private init() { }

    private var deviceUsageCount: Int {
        get { cacheService.getCountForDeviceUsage() }
    }

    private var lastReviewRequestDate: Date? {
        get { cacheService.getDateSinceLastReview() }
    }
    
    private var lastReviewBundleVersion: String? {
        get { cacheService.getLastReviewBundleVersion() }
    }
    
    func incrementDeviceUsageCount() {
        cacheService.incrementCountForDeviceUsage()
    }
    
    func setLastRequestDate() {
        cacheService.setDateForLastReviewRequest()
    }
    
    func shouldRequestReview() -> Bool {
        guard getBundleId() != lastReviewBundleVersion else { return false }
        guard deviceUsageCount >= 5 else { return false }
        guard let lastReviewRequestDate = lastReviewRequestDate else { return true }
        
        return lastReviewRequestDate.timeIntervalSinceNow >= Self.minimumSecondsRequestInterval
    }
    
    @MainActor
    func requestReview(scene: UIWindowScene) {
        SKStoreReviewController.requestReview(in: scene)
        
        if let bundleId = getBundleId() {
            cacheService.setLastReviewBundleVersion(bundleId)
        }
    }
    
    func getBundleId() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}
