//
//  Array+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 1/8/23.
//

import Foundation


extension Array {
    
    mutating func removeFirstOrNil() -> Self.Element? {
        if self.isEmpty {
            return nil
        }
        return self.removeFirst()
    }
    
    mutating func removeFirstOrDefault(_ defaultValue: Self.Element) -> Self.Element {
        if self.isEmpty {
            return defaultValue
        }
        return self.removeFirst()
    }
}
