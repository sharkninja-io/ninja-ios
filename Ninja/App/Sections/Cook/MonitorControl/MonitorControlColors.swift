//
//  MonitorControlColors.swift
//  Ninja
//
//  Created by Martin Burch on 2/24/23.
//

import UIKit

struct MonitorControlColorSet {
    let background: UIColor
    let gradientColors: [CGColor]
    let labelColors: [CGColor]
    let toastColors: [CGColor]
}

class MonitorControlColors {
    
    static func getGradient(state: CalculatedState,
                            type: CAGradientLayerType = .conic,
                            start: CGPoint = CGPoint(x: 0.5, y: 0.5),
                            end: CGPoint = CGPoint(x: 0.5, y: 0.0)) -> CAGradientLayer {
        return getGradient(gradientColors: getColorSet(state: state).gradientColors, type: type, end: end)
    }
    
    static func getGradient(gradientColors: [CGColor] = [],
                            type: CAGradientLayerType = .conic,
                            start: CGPoint = CGPoint(x: 0.5, y: 0.5),
                            end: CGPoint = CGPoint(x: 0.5, y: 0.0)) -> CAGradientLayer {
        let colors: [CGColor] = gradientColors
        let layer = CAGradientLayer()
        layer.type = type
        layer.startPoint = start
        layer.endPoint = end
        layer.colors = colors
        return layer
    }
    
    static func getColorSet(state: CalculatedState) -> MonitorControlColorSet {
        switch state {
        case .Preheating, .Igniting:
            return preheat
        case .AddFood:
            return addFood
        case .Cooking, .FlipFood, .PlugInProbe1, .PlugInProbe2:
            return cooking
        case .Resting:
            return resting
        case .Done, .GetFood:
            return complete
        case .LidOpenBeforeCook, .LidOpenDuringCook:
            return lidOpen
        default:
            return invalid
        }
    }
    
    static let preheat: MonitorControlColorSet = .init(
        background: 0x342D5C.hexToUIColor(),
        gradientColors: [0x716FE7.hexToUIColor().cgColor,
                                     0xA56495.hexToUIColor().cgColor,
                                     0xEE864D.hexToUIColor().cgColor],
        labelColors: [0xA56495.hexToUIColor().cgColor, 0xE3B5D8.hexToUIColor().cgColor],
        toastColors: []
    )
    
    static let addFood: MonitorControlColorSet = .init(
        background: 0x39130D.hexToUIColor(),
        gradientColors: [0xD27843.hexToUIColor().cgColor,
                         0xD55743.hexToUIColor().cgColor],
        labelColors: [0xD55743.hexToUIColor().cgColor, 0xE6CD9B.hexToUIColor().cgColor],
        toastColors: []
    )

    static let lidOpen: MonitorControlColorSet = .init(
        background: 0x39130D.hexToUIColor(),
//        gradientColors: [0xF52A4C.hexToUIColor().cgColor,
//                         0x971B30.hexToUIColor().cgColor,
//                         0x5E0413.hexToUIColor().cgColor],
        gradientColors: [0xf0284a.hexToUIColor().cgColor,
                         0x9e1b32.hexToUIColor().cgColor,
                         0x6d0c1c.hexToUIColor().cgColor],
  
        labelColors: [0xD55743.hexToUIColor().cgColor, 0xE6CD9B.hexToUIColor().cgColor],
        toastColors: [0xF52A4C.hexToUIColor().cgColor, 0x971B30.hexToUIColor().cgColor, 0x5E0413.hexToUIColor().cgColor]
    )

    static let cooking: MonitorControlColorSet = .init(
        background: 0x39130D.hexToUIColor(),
        gradientColors: [0xE6CD9B.hexToUIColor().cgColor,
                         0xEE864D.hexToUIColor().cgColor,
                         0xD26543.hexToUIColor().cgColor,
                         0xD54343.hexToUIColor().cgColor,
                         0xD54343.hexToUIColor().cgColor,
                         0x772135.hexToUIColor().cgColor],
        labelColors: [0xD55743.hexToUIColor().cgColor, 0xE6CD9B.hexToUIColor().cgColor],
        toastColors: [0xD27843.hexToUIColor().cgColor, 0xD55743.hexToUIColor().cgColor, 0x393939.hexToUIColor().cgColor]
    )
    
    static let resting: MonitorControlColorSet = .init(
        background: 0x342D5C.hexToUIColor(),
        gradientColors: [0xA56495.hexToUIColor().cgColor,
                         0x716FE7.hexToUIColor().cgColor,
                         0x716FE7.hexToUIColor().cgColor,
                         0x716FE7.hexToUIColor().cgColor,
                         0x45BE55.hexToUIColor().cgColor,
                         0x45BE55.hexToUIColor().cgColor],
        labelColors: [0x716FE7.hexToUIColor().cgColor, 0xA2659A.hexToUIColor().cgColor],
        toastColors: [0x45BE55.hexToUIColor().cgColor, 0x716FE7.hexToUIColor().cgColor, 0x8B6ABE.hexToUIColor().cgColor, 0xA56495.hexToUIColor().cgColor]
    )
    
    static let complete: MonitorControlColorSet = .init(
        background: 0x45BE55.hexToUIColor(),
        gradientColors: [0x45BE55.hexToUIColor().cgColor],
        labelColors: [0x45BE55.hexToUIColor().cgColor],
        toastColors: []
    )
    
    static let invalid: MonitorControlColorSet = .init(
        background: 0x403960.hexToUIColor(),
        gradientColors: [0x403960.hexToUIColor().cgColor],
        labelColors: [0x403960.hexToUIColor().cgColor],
        toastColors: []
    )
    
    static var heatingColors: [CGColor] = [0xD55743.hexToUIColor().cgColor, 0xE6CD9B.hexToUIColor().cgColor]
    static var coolingColors: [CGColor] = [0x716FE7.hexToUIColor().cgColor, 0xA2659A.hexToUIColor().cgColor]
}
