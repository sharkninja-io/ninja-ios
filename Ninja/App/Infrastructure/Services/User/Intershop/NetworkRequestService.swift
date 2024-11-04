//
//  NetworkRequestService.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 11/23/22.
//

import Foundation

final class NetworkRequestService {
    
    private let decoder: JSONDecoder
    
    internal init() {
        self.decoder = .init()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func get<T>(url: URL, headers: [String: String]) async throws -> T? where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Get.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        Logger.Debug("\(request.curlString)\n")
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let _ = response as? HTTPURLResponse else {
                Logger.Warning("Succesful response was not received by the request.")
                return nil
            }
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, _) {
            Logger.Error("Key '\(key)' not found.")
        } catch let DecodingError.valueNotFound(value, _) {
            Logger.Error("Value '\(value)' not found.")
        } catch let DecodingError.typeMismatch(type, _)  {
            Logger.Error("Type '\(type)' mismatch.")
        } catch let error {
            Logger.Error(error.localizedDescription)
        }
        return nil
    }
    
    public func post<T>(url: URL, headers: [String: String], body: T) async throws where T: Payloadable {
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.Post.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        
        request.httpBody = body.bytes()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        Logger.Debug("\n\(request.curlString)\n")
        
        do {
            let (_, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.Warning("Succesful response was not received by the request.")
                return
            }
            Logger.Debug(httpResponse.isSuccesfulResponse)
        } catch let error {
            Logger.Error(error.localizedDescription)
        }
    }
}
