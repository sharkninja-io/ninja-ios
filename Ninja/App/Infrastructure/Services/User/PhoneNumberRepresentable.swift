//
//  PhoneNumberRepresentable.swift
//  SharkClean
//
//  Created by Jonathan on 2/3/22.
//

import Foundation

struct PhoneNumberRepresentable: RawRepresentable, Codable {
    
    enum PhoneNumberLocal {
        case NorthAmerica
        case China
        
        var code: String {
            switch self {
            case .NorthAmerica:
                return "+1"
            case .China:
                return "+86"
            }
        }
        
        var mask: String {
            switch self {
            case .NorthAmerica:
                return "XXX-XXX-XXXX"
            case .China:
                return "XXX-XXXX-XXXX"
            }
        }
    }
    
    public var rawValue: String
    public var phoneNumberLocal: PhoneNumberLocal = .NorthAmerica
    
    public static let ALLOWED_NUMBER_SET: CharacterSet = .init(charactersIn: "0123456789")
    
    init?(rawValue: String) {
        guard let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        ) else {
            return nil
        }
        
        let trimmed = rawValue.trimmingCharacters(in: .whitespaces)
        
        let range = NSRange(trimmed.startIndex..<trimmed.endIndex, in: trimmed)
        
        let matches = detector.matches(in: trimmed, options: [], range: range)
        
        guard let match = matches.first, matches.count == 1, let number = match.phoneNumber, match.range == range else {
            return nil
        }
        
        self.rawValue = number
    }
    
    public static func format(_ mask: String, input: String) -> String {
        let numbers = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var out = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                out.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                out.append(ch)
            }
        }
        return out
    }
    
    public func phoneNumber(skipCountryCode: Bool = false) -> String {
        let formatted = Self.format(phoneNumberLocal.mask, input: self.rawValue)
        let output = formatted.replacingOccurrences(of: "-", with: "")

        return skipCountryCode ? output : phoneNumberLocal.code + output
    }

}
