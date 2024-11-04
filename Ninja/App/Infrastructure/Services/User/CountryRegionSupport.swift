//
//  CountryRegionSupport.swift
//  SharkClean
//
//  Created by Jonathan on 1/10/22.
//

import Foundation

struct CountryRegionSupport: Equatable, Comparable  {
    
    public static let defaultValue: CountryRegionSupport = .init("US", name: "United States", server: .NorthAmerica)
    
    internal enum CountryRegionServer: String, Codable {
        case NorthAmerica = "NA"
        case Europe = "EU"
        case China = "CN"
        case Unknown
        
        var devEnvironment: String {
            switch self {
            case .NorthAmerica, .China:
                return "\(self.rawValue)-Dev"
            default:
                return self.rawValue
            }
        }
    }
    
    public let code: String
    public let name: String
    public let server: CountryRegionServer
    
    public init(_ code: String, name: String, server: CountryRegionServer) {
        self.code = code
        self.name = name
        self.server = server
    }
    
    public func isCountryRegionCurrentLocale(locale: NSLocale?) -> Bool {
        guard let locale = locale else {
            return false
        }
        
        return code == locale.countryCode
    }
    
    public func getLocalDisplayName(locale: NSLocale?) -> String {
        guard let locale = locale else {
            return name
        }
        
        return locale.displayName(forKey: .countryCode, value: code) ?? name
    }
    
    static func < (lhs: CountryRegionSupport, rhs: CountryRegionSupport) -> Bool {
        return lhs.name < rhs.name
    }
}
