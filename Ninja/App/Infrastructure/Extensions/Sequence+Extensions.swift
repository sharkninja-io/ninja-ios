//
//  Sequence.swift
//  Ninja
//
//  Created by Martin Burch on 1/30/23.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }

}
