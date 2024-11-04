//
//  VideoAssetLibrary.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import Foundation

enum VideoAssetLibrary: String, CaseIterable {
    
    /// Last  '_' before extension
    case splash_smoke_mp4
    
    func toBundlePath() -> String? {
        let dotPosition = self.rawValue.lastIndex(of: "_")
        guard let dotPosition = dotPosition else { return "" }
        return Bundle.main.path(
            forResource: String(self.rawValue[..<dotPosition]),
            ofType: String(self.rawValue[self.rawValue.index(after: dotPosition)...]))
    }
}
