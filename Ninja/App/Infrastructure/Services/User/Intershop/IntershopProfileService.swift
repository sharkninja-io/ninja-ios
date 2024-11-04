//
//  IntershopProfileRegistrationDataSource.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 2/22/23.
//

import Foundation
import GrillCore

final class IntershopProfileService {
    
    private(set) var api: IntershopCustomerApi = IntershopCustomerApi()
    private let urlSession: URLSession = URLSession(configuration: .default)
    
    internal init(api: IntershopCustomerApi = IntershopCustomerApi()) {
        self.api = api
    }
    
    func update(profile: IntershopCustomerApi.Customer) async throws {
        guard let url = URL(string: api.environment.url + IntershopCustomerApi.Endpoints.CustomerDetails.uri) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Put.rawValue

        api.setupHeaders(&request, includeIntershopAuthToken: true)
          
        // Remove the address object so the customer conforms to the expected JSON body
        var body = profile
        var address = body.preferredShipToAddress
        body.preferredShipToAddress = nil
        
        
        request.httpBody = try? body.serialize(strategy: .useDefaultKeys)

        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse  else {
            Logger.Warning("Succesful response was not received by the request.")
            return
        }
        
        self.api.cacheAuthorizationHeaders(httpResponse.allHeaderFields)
        
        var customer = try IntershopCustomerApi.Customer.deserialize(data, strategy: .useDefaultKeys)
        
        // Prepare and attach address
        address?.id = customer.preferredShipToAddress?.id ?? .emptyOrNone
        address?.firstName = customer.firstName
        address?.lastName = customer.lastName
        address?.countryCode = CacheService.shared().getSelectedCountryRegionForUser()
        try await attach(address: address, to: &customer)
    }
    
    private func attach(address: IntershopCustomerApi.Customer.Address?, to customer: inout IntershopCustomerApi.Customer) async throws {
        guard let url = URL(string: api.environment.url + IntershopCustomerApi.Endpoints.AddressById(address?.id ?? String.emptyOrNone).uri) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Put.rawValue
        
        api.setupHeaders(&request, includeIntershopAuthToken: true)
        request.httpBody = try? address?.serialize(strategy: .useDefaultKeys)
        
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse  else {
            Logger.Warning("Succesful response was not received by the request.")
            return
        }
        
        self.api.cacheAuthorizationHeaders(httpResponse.allHeaderFields)
        
        let address = try IntershopCustomerApi.Customer.Address.deserialize(data, strategy: .useDefaultKeys)
        customer.preferredShipToAddress = address
        SettingsViewModel.shared().userProfile = customer
        SettingsViewModel.shared().userProfileDraft = customer
    }
    
    func updateEmail(_ email: String) async throws {
        guard let url = URL(string: api.environment.url + IntershopCustomerApi.Endpoints.CustomerDetails.uri) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Put.rawValue
        api.setupHeaders(&request, includeIntershopAuthToken: true, includeAylaToken: true)
        
        guard var customer = SettingsViewModel.shared().userProfile else {
            Logger.Error("Found nil when fetching Intershop Customer Profile from cache.")
            return
        }
        // Remove the address object so `customer` conforms to the expected JSON body
        customer.preferredShipToAddress = nil
        
        let newEmail = email.hasPrefix("dev@") ? email.replacingOccurrences(of: "dev@", with: String.emptyOrNone) : email
        customer.email = newEmail
        
        request.httpBody = try? customer.serialize(strategy: .useDefaultKeys)
        
        let (_, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse  else {
            Logger.Warning("Succesful response was not received by the request.")
            return
        }
        
        self.api.cacheAuthorizationHeaders(httpResponse.allHeaderFields)
    }
}
