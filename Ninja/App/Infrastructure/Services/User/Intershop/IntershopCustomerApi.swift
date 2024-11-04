//
//  IntershopCustomerApi.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 3/14/23.
//

import Foundation
import GrillCore

final class IntershopCustomerApi {
    private typealias Server = CountryRegionSupport.CountryRegionServer
    
    private let server: Server
    
    public let environment: Environment
    
    public var aylaAcessToken: String?
    
    internal init(country: String = CacheService.shared().getSelectedCountryRegionForUser()) {
        let email = GrillCoreSDK.User.getUsername().unwrapOrNil() ?? ""
        let isDevEnvironment = email.hasPrefix("dev@")
        
        self.server = CacheService.shared().getSelectedCountryServerForUser()
        switch self.server {
        case .NorthAmerica:
            if isDevEnvironment {
                self.environment = .USDevEnvironment
            } else {
                self.environment = country == "CA" ? .Canada : .UnitedStates
            }
        case .Europe:
            self.environment = country == "GB" ? .UnitedKingdom : .Europe
        case .China, .Unknown:
            self.environment = .UnitedStates
        }
    }
    
    public func cacheAuthorizationHeaders(_ headers: [AnyHashable : Any]) {
        if let authenticationToken = headers["authentication-token"] as? String,
           authenticationToken != "AuthenticationTokenInvalid" {
            CacheService.shared().setUserIntershopAuthorizationToken(authenticationToken)
        }
    }
    
    public func getAuthorizationTokenFromCache() -> [String : String] {
        let authenticationToken = CacheService.shared().getUserIntershopAuthorizationToken()
        if authenticationToken != "AuthenticationTokenInvalid" {
            return ["authentication-token": authenticationToken]
        } else {
            return [:]
        }
    }
    
    func setupHeaders(_ request: inout URLRequest, includeIntershopAuthToken: Bool = false, includeAylaToken: Bool = false) {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(environment.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        if includeIntershopAuthToken {
            getAuthorizationTokenFromCache().forEach({ !$0.value.isEmpty ? request.addValue($0.value, forHTTPHeaderField: $0.key) : () })
        }
        
        if includeAylaToken {
            if let aylaAcessToken {
                request.addValue(aylaAcessToken, forHTTPHeaderField: "access-token")
                self.aylaAcessToken = nil
            } else {
                let token = GrillCoreSDK.User.getAccessToken().unwrapOrNil() ?? ""
                request.addValue(token, forHTTPHeaderField: "access-token")
            }
        }
    }
}

extension IntershopCustomerApi {
    enum Environment {
        case Canada
        case Europe
        case UnitedStates
        case UnitedKingdom
        case USDevEnvironment
        
        var url: String {
            switch self {
            case .UnitedStates:
                return "https://sharkninja-prd-cus-001.azure-api.net/icm/b2c/SharkNinja-US-Site/sharkus"
            case .USDevEnvironment:
                return "https://apim-snj-uat-cus-001.azure-api.net/icm/b2c/SharkNinja-US-Site/sharkus/"
            case .Canada:
                return "https://sharkninja-prd-cus-001.azure-api.net/icm/b2c/SharkNinja-CA-Site/sharkca"
            case .Europe:
                return "https://sharkninja.azure-api.net/icm/b2c/SharkNinja-EU-Site/-"
            case .UnitedKingdom:
                return "https://sharkninja.azure-api.net/icm/b2c/SharkNinja-GB-Site/-"
            }
        }
        
        var subscriptionKey: String {
            switch self {
            case .UnitedStates, .USDevEnvironment, .Canada:
                return "c9c2932f4b064f989c5b7caf3ad0793a"
            case .Europe, .UnitedKingdom:
                return "d2290321efb34f3d99fd76c284091761"
            }
        }
    }
}

extension IntershopCustomerApi {
    enum Endpoints {
        case CreateCustomer      // POST
        case CustomerDetails     // GET & PUT
        case AddressById(String) // POST
        
        var uri: String {
            switch self {
            case .CreateCustomer:
                return "/customers/basic"
            case .CustomerDetails:
                return "/customers/-"
            case .AddressById(let customerAddressKey):
                return "/customers/-/addresses/\(customerAddressKey)"
            }
        }
    }
}

extension IntershopCustomerApi {
    struct Customer: JSONObject, Serializable, Equatable {
        var customerNo: String
        var firstName: String?
        var lastName: String?
        var phoneHome: String?
        var email: String
        var preferredShipToAddress: Address?
        
        struct Address: JSONObject, Equatable {
            var urn: String
            var id: String
            var firstName: String?
            var lastName: String?
            var addressName: String?
            var addressLine1: String?
            var addressLine2: String? // Added per the docs. Don't need it, but whatever.
            var mainDivision: String?
            var postalCode: String?
            var country: String?
            var countryCode: String?
            var city: String?
            var street: String?
            var state: String?
            // If you turn this into false it will wipe out your address from your profile
            // which can result in loosing your address id, so keep it true.
            var shipToAddress: Bool = true // preferredShipToAddress Object
            // Funny since this is true, you get two address in your response as duplicated
            var invoiceToAddress: Bool = true // preferredInvoiceToAddress Object
        }
    }
}
