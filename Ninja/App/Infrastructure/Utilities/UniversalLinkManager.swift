//
//  UniversalLinkManager.swift
//  Ninja
//
//  Created by Richard Jacobson on 3/15/23.
//

import UIKit

/*
 Link breakdown by region:
 
 NORTH AMERICA
    Account Confirmation:
    https://www.ninjakitchen.com/login?ConfirmationToken=TOKEN
    Password Reset:
    https://www.ninjakitchen.com/forgotPassword/updatePassword?reset_password_token=TOKEN
 
 UNITED KINGDOM & EUROPEAN UNION
    Account Confirmation:
    https://ninjakitchen.co.uk/myaccount/accountsettings/verify?ConfirmationToken=TOKEN
    Password Reset:
    https://ninjakitchen.co.uk/myaccount/resetpassword?reset_password_token=TOKEN
 */

final class UniversalLinkManager {
    
    private var redirectUri: URL
    private let coldLaunch: Bool
    private let regionLinkManager: RegionLinkManager
    
    init(redirectUri: URL, coldLaunch: Bool) {
        self.redirectUri = redirectUri
        self.coldLaunch = coldLaunch
        self.regionLinkManager = RegionLinkManager(redirectUri)
    }
    
    func redirect(_ window: UIWindow?) {
        // TODO: Remove once AASA files and email templates are updated
        guard !redirectUri.absoluteString.contains("/myaccount/accountsettings/verify/") else {
            Logger.Debug("Appliation Launched by old version of Confirm Email link")
            redirectForOldConfirmEmailPath(window)
            return
        }
        // TODO: --------------
        
        guard let linkType = regionLinkManager.linkType,
              let components = URLComponents(url: redirectUri, resolvingAgainstBaseURL: true),
              let parameters = components.queryItems,
              let token = parameters.first(where: {$0.name == regionLinkManager.getRelevantParamaterName()})?.value else {
            Logger.Error("Application launched by unsupported Universal Link")
            MixpanelService.shared.trackSectionError(.AppLaunch, event: "Unsupported Universal Link", errorDescription: "Given URL: \(redirectUri.absoluteURL)")
            NavigationManager.shared.toAuthentication(window: window)
            return
        }
        
        switch linkType {
        case .confirmEmail:
            redirectForConfirmEmail(window, token: token)
        case .resetPassword:
            redirectForResetPassword(window, token: token)
        }
    }
    
    // TODO: Remove once AASA files and email templates are updated
    private func redirectForOldConfirmEmailPath(_ window: UIWindow?) {
        let token = redirectUri.lastPathComponent
        guard !token.isEmpty, token != "verify" else {
            Logger.Error("No token provided")
            NavigationManager.shared.toAuthentication(window: window)
            return
        }
        
        NavigationManager.shared.toVerifyAccount(window, coldLaunch: coldLaunch)
        
        Task {
            // If we do this too fast, GrillCore seems to lose internet connection
            // Wait one second before attempting to confirm account
            try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
            AuthenticationViewModel.shared().confirmAccount(token: token)
        }
    }
    // TODO: ----------------------
    
    
    private func redirectForConfirmEmail(_ window: UIWindow?, token: String) {
        NavigationManager.shared.toVerifyAccount(window, coldLaunch: coldLaunch)
        
        Task {
            // If we do this too fast, GrillCore seems to lose internet connection
            // Wait one second before attempting to confirm account
            try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
            AuthenticationViewModel.shared().confirmAccount(token: token)
        }
    }
    
    private func redirectForResetPassword(_ window: UIWindow?, token: String) {
        AuthenticationViewModel.shared().resetToken = token
        NavigationManager.shared.toResetPassword(window)
    }
}

extension UniversalLinkManager {
    private struct RegionLinkManager {
        enum LinkType {
            case confirmEmail
            case resetPassword
        }
        
        private enum LinkRegion: CaseIterable {
            case NA
            case UK
            case EU
            
            static func from(_ url: URL) -> LinkRegion {
                for domain in LinkRegion.NA.domains {
                    if url.absoluteString.contains(domain) {
                        return .NA
                    }
                }
                
                if url.absoluteString.contains(LinkRegion.UK.domains[0]) {
                    return .UK
                }
                
                for domain in LinkRegion.EU.domains {
                    if url.absoluteString.contains(domain) {
                        return .EU
                    }
                }
                
                // Default to NA if all else fails.
                return .NA
            }
            
            var domains: [String] {
                switch self {
                case .NA:
                    return ["ninjakitchen.com", "ninjakitchen.ca"]
                case .UK:
                    return ["ninjakitchen.co.uk"]
                case .EU:
                    return ["ninjakitchen.de", "ninjakitchen.fr", "ninjakitchen.es"]
                }
            }
            
            var confirmEmailParameter: String {
                switch self {
                case .NA, .UK, .EU:
                    return "ConfirmationToken"
                }
            }
            
            var confirmEmailLastPathComponent: String {
                switch self {
                case .NA:
                    return "login"
                case .UK, .EU:
                    return "verify"
                }
            }
            
            var passwordResetParameter: String {
                switch self {
                case .NA, .UK, .EU:
                    return "reset_password_token"
                }
            }
            
            var passwordResetLastPathComponent: String {
                switch self {
                case .NA:
                    return "updatePassword"
                case .UK, .EU:
                    return "resetpassword"
                }
            }
        }
        
        private var linkRegion: LinkRegion?
        var linkType: LinkType?
        
        init(_ url: URL) {
            linkRegion = LinkRegion.from(url)
            linkType = parseLinkType(url)
        }
        
        private func parseLinkType(_ url: URL) -> LinkType? {
            guard let linkRegion else { return nil }
            
            if url.lastPathComponent == linkRegion.confirmEmailLastPathComponent {
                return .confirmEmail
            } else if url.lastPathComponent == linkRegion.passwordResetLastPathComponent {
                return .resetPassword
            } else {
                return nil
            }
        }
        
        func getRelevantParamaterName() -> String {
            guard let linkType, let linkRegion else { return "" }
            
            switch linkType {
            case .confirmEmail:
                return linkRegion.confirmEmailParameter
            case .resetPassword:
                return linkRegion.passwordResetParameter
            }
        }
    }
}
