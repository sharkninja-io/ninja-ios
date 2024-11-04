//
//  Collection+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 8/31/22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
