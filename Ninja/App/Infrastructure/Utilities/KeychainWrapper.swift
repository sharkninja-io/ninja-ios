//
//  KeychainWrapper.swift
//  Ninja
//
//  Created by Richard Jacobson on 4/28/23.
//

import Foundation

final class KeychainWrapper {
    
    private static let service: String = "com.sharkninja.ninja"
    
    private init() {}
    
    static func store(_ value: String, itemKey: ItemKey) {
        let data = Data(value.utf8)
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: itemKey.rawValue,
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            Logger.Error("Failed to store item. Error: \(status)")
        }
        
        if status == errSecDuplicateItem {
            Logger.Error("Found existing stored value for \(itemKey). This should never happen")
            // Update already existing value
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: itemKey.rawValue,
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            
            let attributes = [kSecValueData: data] as CFDictionary
            
            let status = SecItemUpdate(query, attributes)
            if status != errSecSuccess {
                Logger.Error("Failed to update item. Error: \(status)")
            }
        }
    }
    
    static func fetch(_ itemKey: ItemKey) -> String {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: itemKey.rawValue,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        guard let value = result as? Data else {
            Logger.Error()
            return ""
        }
        
        return String(decoding: value, as: UTF8.self)
    }
    
    static func deleteItem(_ itemKey: ItemKey) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: itemKey.rawValue,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemDelete(query)
        if status != errSecSuccess {
            Logger.Error("Failed to delete item. Error: \(status)")
        }
    }
}

extension KeychainWrapper {
    enum ItemKey: String {
        case username = "SharkNinjaUsername"
        case password = "SharkNinjaPassword"
    }
}
