//
//  AuthenticationService.swift
//  Ninja
//
//  Created by Martin Burch on 8/18/22.
//

import Foundation
import GrillCore
import Bugsnag
import Combine

class AuthenticationService {
    
    struct AuthenticationResponse {
        var isSuccess: Bool
        var error: Error? = nil
    }
    
    // TODO: Holds latest logged in status as CloudCore is the source of truth
    public var isLoggedInSubject = CurrentValueSubject<Bool,Never>(false)
    
    private static var _instance: AuthenticationService = .init()
    static func shared() -> AuthenticationService {
        return _instance
    }
    
    func getUserId() -> String? {
        GrillCoreSDK.User.getUUID().unwrapOrNil()
    }

    // MARK: LOGIN
    func login(email: String, password: String) async -> Bool {
        // TODO: check internet connection!!!
        let result = await GrillCoreSDK.User.login(email: email, password: password)
        var success = false
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Login Success", properties: ["With Phone Number": false])
            if let userUUID = GrillCoreSDK.User.getUUID().unwrapOrNil() {
                // MARK: - removed for Metrics
                // Bugsnag.setUser(userUUID, withEmail: nil, andName: nil)
                MixpanelService.shared.identify(uniqueId: userUUID)
            }
            self.isLoggedInSubject.send(true)
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Login", errorDescription: err.localizedDescription)
            Logger.Error(err)
            self.isLoggedInSubject.send(false)
        }
        return success
    }
    
    func logout() async -> Bool {
        let result = await GrillCoreSDK.User.logout()
        var success = false
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Logout Success", properties: [:])
            self.isLoggedInSubject.send(false)
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Logout", errorDescription: err.localizedDescription)
            Logger.Error(err)
            self.isLoggedInSubject.send(false)
        }
        return success
    }
    
    func isLoggedIn() -> Bool {
        let result = GrillCoreSDK.User.getUsername().unwrapOrNil() != nil
        isLoggedInSubject.send(result)
        MixpanelService.shared.identify(uniqueId: GrillCoreSDK.User.getUUID().unwrapOrFallback(fallback: ""))
        return result
    }
    
    // MARK: CREATE ACCOUNT
    func createAccount(email: String, password: String, emailTemplateId: String?) async -> AuthenticationResponse {
        let result = await GrillCoreSDK.User.create(
            password: password,
            email: email,
            emailTemplateId: emailTemplateId
        )
        var response = AuthenticationResponse(isSuccess: false)
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Account Created", properties: ["With Phone Number": false])
            if let userUUID = GrillCoreSDK.User.getUUID().unwrapOrNil() {
                MixpanelService.shared.identify(uniqueId: userUUID)
            }
            response.isSuccess = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Account Creation", errorDescription: err.localizedDescription)
            Logger.Error(err)
            response.error = err
        }
        return response
    }
    
    func confirmAccount(token: String) async -> Bool {
        let result = await GrillCoreSDK.User.confirmAccount(token: token)
        var success = false
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Account Confirmed")
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Account Confirmation", errorDescription: err.localizedDescription)
            Logger.Error(err)
        }
        return success
    }
    
    func sendConfirmation(email: String, emailTemplateId: String?) async -> Bool {
        let result = await GrillCoreSDK.User.confirmAccountRequest(
            email: email,
            emailTemplateId: emailTemplateId
        )
        var success = false
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Sent Confirmation Email")
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Sending Confirmation Email", errorDescription: err.localizedDescription)
            Logger.Error(err)
        }
        return success
    }
    
    
    // MARK: DELETE ACCOUNT
    func deleteAccount(logOutOnSuccess: Bool = false) async -> Bool {
        let result = await GrillCoreSDK.User.delete()
        var success = false
        result.onSuccess() { [weak self] _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Account Deleted")
            if logOutOnSuccess {
                self?.isLoggedInSubject.send(false)
            }
            success = true
        }.onFailure() { err in
            Logger.Error(err.localizedDescription)
            MixpanelService.shared.trackSectionError(.Auth, event: "Account Deleted", errorDescription: err.localizedDescription)
        }
        return success
    }
    

    // MARK: PASSWORD
    // RESET PASSWORD
    func requestPasswordReset(email: String, emailTemplateId: String?) async -> Bool {
        let result = await GrillCoreSDK.User.requestPasswordReset(
            email: email,
            emailTemplateId: emailTemplateId
        )
        var success = false
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Password Reset Request")
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Password Reset Request", errorDescription: err.localizedDescription)
            Logger.Error(err)
        }
        return success
    }
    
    func resetPassword(token: String, password: String) async -> Bool {
        let result = await GrillCoreSDK.User.resetPassword(
            token: token,
            password: password,
            passwordConfirmation: password
        )
        var success = false
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Password Reset")
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Password Reset", errorDescription: err.localizedDescription)
            Logger.Error(err)
        }
        return success
    }
    
    // CHANGE PASSWORD
    /// Change the password while already singed in. Does not require 2FA code.
    func changePassword(password: String, newPassword: String) async -> Bool {
        var success = false
        let result = await GrillCoreSDK.User.resetUserPassword(currentPassword: password, newPassword: newPassword)
        result.onSuccess { _ in
            MixpanelService.shared.trackSectionEvent(.Auth, event: "Password Changed")
            success = true
        }.onFailure { err in
            MixpanelService.shared.trackSectionError(.Auth, event: "Password Changed", errorDescription: err.localizedDescription)
            Logger.Error(err)
        }
        return success
    }
}

extension AuthenticationService {
    func userLoginWithIntershop(emailAddress: String) async {
        Task {
            do {
                try await IntershopAccountService().signIn(username: emailAddress)
            } catch let error {
                Logger.Error(error)
                MixpanelService.shared.trackSectionError(.Auth, event: "IntershopSignIn", errorDescription: error.localizedDescription)
            }
        }
    }
}
