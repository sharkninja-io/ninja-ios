//
//  String+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import Foundation

extension String {
    static var emptyOrNone: String = ""
    
    func containsUppercaseCharacter() -> Bool {
        return self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }

    func containsLowercaseCharacter() -> Bool {
        return self.rangeOfCharacter(from: .lowercaseLetters) != nil
    }
    
    func containsDigit() -> Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
    
    public var isEmail: Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = detector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: self.count))

        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func trimWhiteSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}

extension String {
    
    func toModel<T: Decodable>(trim: Bool = true) throws -> T {
        let string = trim ? self.trimNonJsonCharacters() : self
        guard let data = string.data(using: .utf8) else {
            throw "Unable to convert to binary.:\(self)".asError()
        }
        return try data.toModel()
    }
    
    func trimNonJsonCharacters() -> String {
        var result = self
        if let range = result.range(of: "{") {
            result.removeSubrange(result.startIndex..<range.lowerBound)
        }
        result = String(result.reversed())
        if let range = result.range(of: "}") {
            result.removeSubrange(result.startIndex..<range.lowerBound)
        }
        result = String(result.reversed())
        return result
    }
    
    func asError(code: Int = 0) -> Error {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: self])
    }
}

extension String {
    static let temperatureSymbol: String = "°"
}
