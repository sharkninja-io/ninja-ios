//
//  Data+Extensions.swift
//  SharkClean
//
//  Created by Jonathan on 5/18/22.
//

import Foundation

extension Data {
    var prettyJson: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return string
    }
    
    var json: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: []),
              let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return string
    }
}

extension Data {
    var hex: String {
        return map { String(format: "%02lX", $0) }.joined()
    }
}

extension Data {
    func toModel<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter.CODABLE)
        return try decoder.decode(T.self, from: self)
    }
}

struct GenericCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

extension JSONEncoder.KeyEncodingStrategy {
    static var convertToLowercase: JSONEncoder.KeyEncodingStrategy {
        return .custom { codingKeys in
            let key = GenericCodingKey(stringValue: codingKeys.last!.stringValue.lowercased())
            return key
        }
    }
}
