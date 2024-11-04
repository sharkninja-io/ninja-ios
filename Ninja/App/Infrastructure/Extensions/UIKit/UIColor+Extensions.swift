//
//  UIColor+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/9/22.
//

import UIKit

extension UIColor {
    
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    static func getGradientAsColor(rect: CGRect, colors: [CGColor], isHorizontal: Bool = true) -> UIColor? {
        if colors.count == 1 {
            return UIColor(cgColor: colors[0])
        }
        
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer {
            currentContext?.restoreGState()
        }

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil) {
            let context = UIGraphicsGetCurrentContext()
            let endPoint = isHorizontal ? CGPoint(x: rect.size.width, y: 0) : CGPoint(x: 0, y: rect.size.height)
            context?.drawLinearGradient(gradient, start: CGPoint.zero, end: endPoint, options: [])
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let gradientImage = gradientImage {
                return UIColor(patternImage: gradientImage)
            }
        }
        
        return nil
    }

    static func getColorFromGradientAt(colors: [CGColor], percent: CGFloat) -> UIColor {
        if colors.isEmpty { return .black }
        if colors.count == 1 { return UIColor(cgColor: colors[0]) }
        
        let startBlock = Int(floor(percent * Double(colors.count - 1)))
        let endBlock = Int(ceil(percent * Double(colors.count - 1)))
        let blockPercent = percent * Double(colors.count - 1) - Double(startBlock)
        
        var (redStart, greenStart, blueStart, alphaStart) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (redEnd, greenEnd, blueEnd, alphaEnd) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        UIColor(cgColor: colors[startBlock]).getRed(&redStart, green: &greenStart, blue: &blueStart, alpha: &alphaStart)
        UIColor(cgColor: colors[endBlock]).getRed(&redEnd, green: &greenEnd, blue: &blueEnd, alpha: &alphaEnd)
        
        return UIColor(red: (redStart + ((redEnd - redStart) * blockPercent)),
                       green: (greenStart + ((greenEnd - greenStart) * blockPercent)),
                       blue: (blueStart + ((blueEnd - blueStart) * blockPercent)),
                       alpha: (alphaStart + ((alphaEnd - alphaStart) * blockPercent)))
    }
}
