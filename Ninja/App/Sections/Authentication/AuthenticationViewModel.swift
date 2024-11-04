//
//  AuthenticationViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 9/13/22.
//

import Foundation
import Combine

enum AuthenticationUpdateEvent {
    case LoggedIn
    case LogInFailed
    case LoggedOut
    case LogOutFailed
    case AccountCreated
    case AccountCreationFailed(Error?)
    case ConfirmationSent
    case ConfirmationSendFailed
    case AccountConfirmed
    case AccountConfirmationFailed
    case RequestedPasswordReset
    case RequestedPasswordResetFailed
    case PasswordReset
    case PasswordResetFailed
}

class AuthenticationViewModel {
    
    private lazy var authenticationService = AuthenticationService.shared()
    private lazy var cacheService = CacheService.shared()
    
    /// Password RegEx pattern
    public let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}$"
    
    private var countryRegion = CountryRegionSupport.defaultValue
    private var server: CountryRegionSupport.CountryRegionServer = .NorthAmerica
    
    public var email: String = "" // Sharable across pages
    public var createPassword: String? // DO NOT CACHE!!!
    public var resetToken: String?
    
    /// Subjects
    public var isLoggedInSubject: CurrentValueSubject<Bool, Never> {
        get {
            return authenticationService.isLoggedInSubject
        }
    }
    public var authenticationUpdateSubject = PassthroughSubject<AuthenticationUpdateEvent, Never>()
    public var isPasswordReset: Bool = false
    public var accountExists: Bool = false
    
    private static var _viewModel: AuthenticationViewModel = .init()
    public static func shared() -> AuthenticationViewModel {
        return _viewModel
    }
    
    // TODO: Terms and Conditions???
    private init() {
        loadCountryRegion()
    }
    
    // MARK: REGION
    func loadCountryRegion() {
        let countryRegionCode = cacheService.getSelectedCountryRegionForUser()
        countryRegion = CountryRegionManager.shared.getLocale(countryRegionCode) ?? CountryRegionSupport.defaultValue
        server = cacheService.getSelectedCountryServerForUser()
    }
    
    func storeCountryRegion() {
        // Store only if empty
        let storedCountry = cacheService.getSelectedCountryRegionForUser()
        if storedCountry.isEmpty {
            cacheService.setSelectedCountryRegionForUser(countryRegion)
        }
    }
    
    func setCountryRegion(countryRegion: CountryRegionSupport) {
        // Set only if empty
        let storedCountry = cacheService.getSelectedCountryRegionForUser()
        if storedCountry.isEmpty {
            self.countryRegion = countryRegion
            self.server = countryRegion.server
        }
    }
    
    func isCountryCached() -> Bool {
        return !cacheService.getSelectedCountryRegionForUser().isEmpty
    }
        
    // MARK: LOGIN
    func getUserId() -> String? {
        return authenticationService.getUserId()
    }
    
    func isLoggedIn() -> Bool {
        let loggedIn = authenticationService.isLoggedIn()
        
        authenticationUpdateSubject.send(loggedIn ? .LoggedIn : .LoggedOut)
        
        return loggedIn
    }
    
    func login(email: String, password: String) {
        self.email = email
        Task {
            guard let email = getValidEmail(self.email) else { return }
            
            let result = await authenticationService.login(email: email, password: password)
            
            if result {
                await authenticationService.userLoginWithIntershop(emailAddress: email)
            }

            authenticationUpdateSubject.send(result ? .LoggedIn : .LogInFailed)

            if result {
                storeCountryRegion()
            }
        }
    }
    
    func logout() {
        Task {
            let result = await authenticationService.logout() // No need to "Log out" with Intershop
            authenticationUpdateSubject.send(result ? .LoggedOut : .LogOutFailed)
        }
    }
    
    // MARK: CREATE ACCOUNT
    func createAccount(email: String, password: String) {
        self.email = email
        Task {
            guard let email = getValidEmail(self.email) else { return }

            let template = getCreateAccountEmailTemplate(email: email)

            let result = await authenticationService.createAccount(email: email, password: password, emailTemplateId: template)
            
            authenticationUpdateSubject.send(result.isSuccess ? .AccountCreated : .AccountCreationFailed(result.error))

            if result.isSuccess {
                storeCountryRegion()
                KeychainWrapper.store(email, itemKey: .username)
                KeychainWrapper.store(password, itemKey: .password)
            }
        }
    }
    
    func sendConfirmation(email: String) {
        Task {
            guard let email = getValidEmail(email) else { return }
            let template = getCreateAccountEmailTemplate(email: email)

            let result = await authenticationService.sendConfirmation(email: email, emailTemplateId: template)
            
            authenticationUpdateSubject.send(result ? .ConfirmationSent : .ConfirmationSendFailed)
        }
    }
    
    func confirmAccount(token: String) {
        Task {
            let result = await authenticationService.confirmAccount(token: token)
            authenticationUpdateSubject.send(result ? .AccountConfirmed : .AccountConfirmationFailed)
        }
    }
    
    // MARK: RESET PASSWORD
    func requestPasswordReset(email: String) {
        self.email = email
        Task {
            guard let email = getValidEmail(email) else { return }
            let template = getPasswordResetEmailTemplate(email: email)
            
            let result = await authenticationService.requestPasswordReset(email: email, emailTemplateId: template)
            
            authenticationUpdateSubject.send(result ? .RequestedPasswordReset : .RequestedPasswordResetFailed)
        }
    }
    
    func resetPassword(token: String, password: String) {
        Task {
            let result = await authenticationService.resetPassword(token: token, password: password)
            
            authenticationUpdateSubject.send(result ? .PasswordReset : .PasswordResetFailed)
            
            isPasswordReset = true
        }
    }
    
    // MARK: HELPERS
    func isDevEmail(_ email: String) -> Bool {
        return email.hasPrefix("dev@")
    }
    
    func trimDevEmail(email: String) -> String {
        if email.hasPrefix("dev@") {
            return String(email.dropFirst(4))
        }
        return email
    }

    func getValidEmail(_ email: String) -> String? {
        return email.isEmail ? email : nil
    }
    
    func getValidPhoneNumber(_ phoneNumber: String) -> String? {
        var phoneRepresentable = PhoneNumberRepresentable(rawValue: phoneNumber)
        phoneRepresentable?.phoneNumberLocal = server == .NorthAmerica ? .NorthAmerica : .China
        return phoneRepresentable?.phoneNumber()
    }
    
    func isEmailTakenError(_ error: Error?) -> Bool {
        // TODO: HACKY
        return error.debugDescription.contains("has already been taken")
    }
    
    func recommendDomain(email: String) -> String? {
        guard email.firstIndex(of: "@") != nil else { return nil }
        let gmails = ["gamil.com", "gmai.com", "gmail.co",
                      "gmail.con", "gmail.org", "gmailc.om",
                      "gmaill.com", "gmal.com", "gmall.com",
                      "gmil.com", "gnail.com", "gmsil.com"]
        let hotmails = ["hitmail.com", "hormail.com", "hotail.com",
                        "hotmai.com", "hotmail.co", "hotmail.con",
                        "hotmaill.com", "hotmial.com"]
        let yahoos = ["tahoo.com", "yaho.com", "yahoo.co",
                      "yahoo.con", "yanoo.com", "yaoo.com",
                      "yhoo.com", "yshoo.com"]
        let iclouds = ["icloid.com", "icoud.com", "iloud.con"]
        let aols = ["ail.com"]
        
        let emailAfterAt = email.components(separatedBy: "@")[1]
        
        if gmails.contains(emailAfterAt) {
            return "gmail.com"
        } else if hotmails.contains(emailAfterAt) {
            return "hotmail.com"
        } else if iclouds.contains(emailAfterAt) {
            return "icloud.com"
        } else if yahoos.contains(emailAfterAt) {
            return "yahoo.com"
        } else if aols.contains(emailAfterAt) {
            return "aol.com"
        } else {
            return nil
        }
    }
    
    private func getCreateAccountEmailTemplate(email: String) -> String {
        // Determine Production or Dev domain
        let environment = isDevEmail(email) ? server.devEnvironment : server.rawValue
        return Localizable("global_email_template_conf-\(environment)").value
    }
    
    private func getPasswordResetEmailTemplate(email: String) -> String {
        // Determine Production or Dev domain
        let environment = isDevEmail(email) ? server.devEnvironment : server.rawValue
        return Localizable("global_email_template_restpwd-\(environment)").value
    }
}
