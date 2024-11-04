//
//  Int+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 8/22/22.
//

import UIKit

extension Int {
    static func getRange(start: Int, stop: Int, step: Int) -> [Int] {
        guard start <= stop, step > 0 else { return [] }
        
        var intArray = Array(repeating: start, count: (stop - start / step) + 1)
        for (index, _) in intArray.enumerated() {
            intArray[index] = start + (index * step)
        }
        return intArray
    }
    
    func hexToUIColor(alpha: Double = 1.0) -> UIColor {
        // expected: 0xRRGGBB
        let red = self >> 16 & 0xFF
        let green = self >> 8 & 0xFF
        let blue = self & 0xFF
        
        return .init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
    
    func convertSecondsToHourMinuteString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full

        let formattedString = formatter.string(from:TimeInterval(self))!
        return formattedString
    }
    
    func convertSecondsToHourMinuteStringShortStyle() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from:TimeInterval(self))!
        return formattedString
    }
}
