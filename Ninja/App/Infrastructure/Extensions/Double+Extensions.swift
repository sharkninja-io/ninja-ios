//
//  Double+Extensions.swift
//  Ninja
//
//  Created by Richard Jacobson on 2/16/23.
//

import Foundation

extension Double {
    /// Returns an **integer** of the value converted to Fahrenheit. Rounded to the nearest whole number.
    ///
    /// - Note: This function does not know if the given number is, in fact, a temperature value in Celsius. It only plugs the number into the function and returns the result.
    func convertToCelsius() -> Int {
        return Int((self - 32) / 1.8)
    }
    
    /// Returns an **integer** of the value converted to Celsius. Rounded to the nearest whole number.
    ///
    /// - Note: This function does not know if the given number is, in fact, a temperature value in Fahrenheit. It only plugs the number into the function and returns the result.
    func convertToFahrenheit() -> Int {
        return Int((self * 1.8) + 32)
    }
}
