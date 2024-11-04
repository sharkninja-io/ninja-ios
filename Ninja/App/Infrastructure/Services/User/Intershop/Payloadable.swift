//
//  Payloadable.swift
//  SharkClean
//
//  Created by Jonathan on 5/18/22.
//

import Foundation

protocol Payloadable where Self: Codable {}

extension Payloadable {
    static func parse(_ data: Data, strategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        return try decoder.decode(Self.self, from: data)
    }
    
    func stringify(strategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> NSString {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = strategy
        let output = String(data: self.bytes(strategy: strategy), encoding: .utf8)!
        return output.data(using: .utf8)!.prettyJson!
    }
   
    func dictionaries() -> [[String: Any]] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(
                with: data, options: .allowFragments
              ) as? [[String: Any]] else {
            return [[:]]
        }
        return dictionary
    }
    
    func dictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(
                with: data, options: .allowFragments
              ) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
    
    func bytes(strategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = strategy
        guard let data = try? encoder.encode(self) else {
            return Data()
        }; return data
    }
    
    func body() -> NSString {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else {
            return "{ }"
        }
        let output = String(data: data, encoding: .utf8)!
        return output.data(using: .utf8)!.prettyJson!
    }
}
