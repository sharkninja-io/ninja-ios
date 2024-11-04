//
//  IntershopAccountEnrollmentDataSource.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 2/22/23.
//

import Foundation
import GrillCore

final class IntershopAccountService {
    
    private(set) var api: IntershopCustomerApi = IntershopCustomerApi()
    private let urlSession: URLSession = URLSession(configuration: .default)
    
    internal init(api: IntershopCustomerApi = IntershopCustomerApi()) {
        self.api = api
    }
    
    func signIn(username: String? = nil) async throws {
        // Get email from GrillCore if not provided
        var email: String
        if let username {
            email = username
        } else {
            guard let gcUsername = GrillCoreSDK.User.getUsername().unwrapOrNil() else { return }
            email = gcUsername
        }
        
        guard let url = URL(string: api.environment.url + IntershopCustomerApi.Endpoints.CustomerDetails.uri) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Get.rawValue
        api.setupHeaders(&request, includeAylaToken: true)
        
        // Attempt to create account if one does not exist
        try? await self.signUp(username: email)
        
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.Warning("Succesful response was not received by the request.")
            return
        }
        
        self.api.cacheAuthorizationHeaders(httpResponse.allHeaderFields)
        
        let customer = try IntershopCustomerApi.Customer.deserialize(data, strategy: .useDefaultKeys)
        SettingsViewModel.shared().userProfile = customer
        SettingsViewModel.shared().userProfileDraft = customer
    }
    
    private func signUp(username: String) async throws {
        guard let url = URL(string: api.environment.url + IntershopCustomerApi.Endpoints.CreateCustomer.uri) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Post.rawValue
        api.setupHeaders(&request)
        
        let email: String = username.hasPrefix("dev@") ? username.replacingOccurrences(of: "dev@", with: String.emptyOrNone) : username
        struct Body: JSONObject { public let login: String }
        let body = Body(login: email)
        request.httpBody = try? body.serialize()
        
        let (_, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.Warning("Succesful response was not received by the request.")
            return
        }
        
        self.api.cacheAuthorizationHeaders(httpResponse.allHeaderFields)
    }
}
