//
//  PhoneNumberManager.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/12/22.
//

import Foundation
import UIKit

struct PhoneNumberManager {
    
    enum Mask: String {
        case nonUsNumber = "+XX (XXX) XXX-XXXX"
        case usNumber = "+X (XXX) XXX-XXXX"
    }
    
    static func format(phone: String, country: Country = .UnitedStates, isFromAutoFill: Bool = false) -> String {
        // Get only numbers from string
        var numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        // Add country code if necessary
        let countryCode = country.phoneNumberCountryCode
        let userIsUsOrCa = country == .UnitedStates || country == .Canada
        if let countryCode {
            if userIsUsOrCa, (numbers.count == 1 || isFromAutoFill), numbers.first != "1" {
                numbers = "1" + numbers
            } else if !userIsUsOrCa, (numbers.count == 2 || isFromAutoFill), numbers.prefix(2) != "\(countryCode)" {
                numbers = "\(countryCode)" + numbers
            }
        }
        
        // Apply Mask
        let mask: Mask = countryCode == 1 ? .usNumber : .nonUsNumber

        for ch in mask.rawValue where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    /// Returns the area code from a properly formatted phone number.
    ///
    /// The provided phone number must have its area code enclosed in parentheses. Otherwise, this will return `nil`
    static func parseForAreaCode(_ phoneNumber: String?) -> String? {
        guard let phoneNumber else { return nil }
        
        // Protect from "Index out of range" crashes
        guard phoneNumber.contains("("), phoneNumber.contains(")") else { return nil }
        
        // There's probably a cleaner way to do this, but it works
        let firstBreak = phoneNumber.components(separatedBy: "(")
        let secondBreak = firstBreak[1].components(separatedBy: ")").dropLast()

        let areaCode = secondBreak[0]
        
        guard areaCode.count == 3 else { return nil}
        return areaCode
    }
    
    /// Returns the provided phone number with no area code, hyphens, nor whitespace
    ///
    /// Will return `nil` if provided number does not match one of the phone number masks
    static func parseForNumberWithoutAreaCode(_ phoneNumber: String?) -> String? {
        guard let phoneNumber, phoneNumber.contains(")"), phoneNumber.contains("-"), phoneNumber.contains(" ") else { return nil }

        let split = phoneNumber.components(separatedBy: ")")
        
        let noHyphens = String(split[1]).replacingOccurrences(of: "-", with: "", options: .literal)
        
        let noWhiteSpace = noHyphens.replacingOccurrences(of: " ", with: "", options: .literal)
        
        return noWhiteSpace
    }
}
