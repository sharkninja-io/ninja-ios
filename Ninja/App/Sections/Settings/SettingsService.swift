//
//  SettingsService.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/17/22.
//

import Foundation
import GrillCore

class SettingsService {
    
    lazy var intershopApi: IntershopCustomerApi = .init()
    
    private static var _instance: SettingsService = .init()
    static func shared() -> SettingsService {
        return _instance
    }
    
    func updateEmail(newEmail: String) async -> Bool {
        var success = false
        let result = await GrillCoreSDK.User.updateEmail(newEmail: newEmail)
        result.onSuccess { _ in
            success = true
        }.onFailure { err in
            success = false
            Logger.Error(err)
        }
        return success
    }
    
    func updateEmailWithIntershop(newEmail: String) async throws {
        Logger.Debug()
        do {
            try await IntershopProfileService(api: intershopApi).updateEmail(newEmail)
        } catch let error {
            throw error
        }
    }
    
    // MARK: Appliance
    func getGrillDetails(_ grill: Grill) async -> GrillCoreSDK.GrillDetails? {
        if let details = await grill.details().unwrapOrNil() {
            return details
        } else {
            Logger.Debug("No details found for grill: \(grill.getName())")
            return nil
        }
    }
    
    func getGrillErrorLog(_ grill: Grill) async -> [GrillCoreSDK.GrillError] {
        if let errors = await grill.errors().unwrapOrNil() {
            return errors
        } else {
            Logger.Debug("No logged errors found for grill: \(grill.getName())")
            return []
        }
    }
    
    func resetFactorySettings(_ grill: Grill?) async -> Bool {
        guard let grill else {
            Logger.Error("No Grill provided")
            return false
        }
        
        var success: Bool = false
        
        await grill.factoryReset()
            .onSuccess(action: {
                success = true
            })
            .onFailure(action: { err in
            Logger.Error(err)
            success = false
        })
        
        return success
    }
    
    func deleteAppliance(_ grill: Grill?) async -> Bool {
        guard let grill else {
            Logger.Error("No Grill provided")
            return false
        }
        
        var success: Bool = false

        await grill.delete()
            .onSuccess(action: {
                success = true
            })
            .onFailure(action: { err in
            Logger.Error(err)
            success = false
        })
        
        return success
    }
}
