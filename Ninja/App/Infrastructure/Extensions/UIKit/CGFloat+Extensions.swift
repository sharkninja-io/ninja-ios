//
//  CGFloat+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 8/23/22.
//

import UIKit

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
    
    func toDegrees() -> CGFloat {
        return self * 180.0 / CGFloat(Double.pi)
    }
}
