//
//  JSONObject.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 11/30/22.
//

import Foundation

protocol JSONObject where Self: Codable & CustomStringConvertible {
    func serialize() throws -> [AnyHashable: Any]
    func serialize(strategy: JSONEncoder.KeyEncodingStrategy) throws -> Data

    static func deserialize(_ data: Data, strategy: JSONDecoder.KeyDecodingStrategy) throws -> Self
}

extension JSONObject {
    var description: String {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(self),
            let result = String(data: data, encoding: .utf8) {
            return result
        }
        return "{}"
    }
}

extension JSONObject {
    func serialize() throws -> [AnyHashable: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable: Any]
        return dictionary ?? [:]
    }
    
    func serialize(strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        encoder.outputFormatting = .sortedKeys
        return try encoder.encode(self)
    }
    
    static func deserialize(_ data: Data, strategy: JSONDecoder.KeyDecodingStrategy) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        return try decoder.decode(Self.self, from: data)
    }
}
