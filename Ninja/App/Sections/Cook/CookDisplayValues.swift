//
//  CookDisplayValues.swift
//  Ninja
//
//  Created by Martin Burch on 2/28/23.
//

import UIKit
import GrillCore

class CookDisplayValues {
    
    enum TimeDisplayUnits {
        case Seconds
        case Minutes
        case Hours
        case Full
    }
    
    static let disabledThermometerCookModes: [CookMode] = [.Broil, .Dehydrate]
    
    static func getModeImage(cookMode: CookMode) -> UIImage? {
        switch cookMode {
        case .Roast:
            return IconAssetLibrary.ico_mode_roast.asImage()
        case .Bake:
            return IconAssetLibrary.ico_mode_bake.asImage()
        case .AirCrisp:
            return IconAssetLibrary.ico_mode_air_crisp.asImage()
        case .Grill:
            return IconAssetLibrary.ico_mode_grill.asImage()
        case .Smoke:
            return IconAssetLibrary.ico_mode_smoke.asImage()
        case .Dehydrate:
            return IconAssetLibrary.ico_mode_dehydrate.asImage()
        case .Broil:
            return IconAssetLibrary.ico_mode_broil.asImage()
        default:
            return IconAssetLibrary.ico_mode_grill.asImage() // TODO: - default value???
        }
    }
    
    static func getModeDisplayName(cookMode: CookMode) -> String {
        switch cookMode {
        case .Grill:
            return "Grill"
        case .Smoke:
            return "Smoker"
        case .AirCrisp:
            return "Air Crisp"
        case .Roast:
            return "Roast"
        case .Bake:
            return "Bake"
        case .Broil:
            return "Broil"
        case .Dehydrate:
            return "Dehydrate"
        case .NotSet:
            return ""
        case .Unknown:
            return ""
        default:
            return String(describing: cookMode)
        }
    }
    
    static func getModeTimeDisplayString(cookMode: CookMode, time: Int) -> String {
        switch cookMode {
        case .Broil:
            return getTimeDisplayString(seconds: time, units: .Minutes)
        default:
            return getTimeDisplayString(seconds: time, units: .Hours)
        }
    }

    static func getTemperatureDisplayString(temp: Int, units: String, mode: CookMode = .Unknown, isThermometer: Bool = false) -> String {
        switch units {
        case "TempMode":
            if temp > 0 && temp < 4 {
                return ["Lo","Med","Hi"][temp - 1]
            }
            return "\(temp)\(shortUnits[""] ?? "")"
        default:
            if temp == 135 && mode == .Smoke && !isThermometer {
                return "CLD"
            }
            return "\(temp)\(shortUnits[units] ?? "")"
        }
    }

    static let shortUnits: [String:String] = [
        "TempMode": "Mode",
        "DegreesFahrenheit": "°F",
        "DegreesCelcius": "°C",
        "Seconds": "Sec",
        "Minutes": "Min",
        "Hours": "Hrs",
        "None": "",
        "°F": "°F",
        "°C": "°C",
        "": "°F" // TODO: - no unit default to fahrenheit
    ]
    
    static func getTimeDisplayString(seconds: Int, units: TimeDisplayUnits) -> String {
        let last = seconds % 60
        let middle = Int(floor(Double(seconds) / 60.0)) % 60
        let first = Int(floor(Double(seconds) / 3600.0))
        var result = ""
        switch units {
        case .Full:
            result = String(format: "%2d:%02d:%02d", first, middle, last)
        case .Hours:
            result = String(format: "%2d:%02d", first, middle)
        case .Minutes:
            result = String(format: "%2d:%02d", middle, last)
        case .Seconds:
            result = String(format: "%02d", last)
        }
        return result.trimmingCharacters(in: [" "])
    }
    
    static func getTimeDisplayString(time: Int, units: String) -> String {
        let last = time % 60
        let middle = Int(floor(Double(time) / 60.0)) % 60
        let first = Int(floor(Double(time) / 3600.0))
        var result = ""
        if units == "Seconds" {
            result = String(format: "%2d:%02d:%02d", first, middle, last)
        } else if units == "Minutes" {
            result = String(format: "%2d:%02d", middle, last)
        }
        return result.trimmingCharacters(in: [" "])
     }
    
    static func getFoodDisplayName(food: Food) -> String {
        switch food {
        case .Manual:
            return "Manual"
        case .Chicken:
            return "Chicken"
        case .Beef:
            return "Beef"
        case .Pork:
            return "Pork"
        case .Fish:
            return "Fish"
        case .NotSet:
            return ""
        default:
            return String(describing: food)
        }
    }
    
    static func getCalculatedStateDisplayName(state: CalculatedState) -> String {
        switch state {
        case .Calculating:
            return "Calculating"
        case .Cooking:
            return "Cooking"
        case .Idle:
            return "Idle"
        case .Igniting:
            return "Ignition"
        case .Offline:
            return "Offline"
        case .Preheating:
            return "Preheating"
        case .ProbeNotSet:
            return "Probe Not Set"
        case .Resting:
            return "Resting"
        case .AddFood:
            return "Add\nFood"
        case .GetFood:
            return "Get Food".uppercased()
        case .PlugInProbe1, .PlugInProbe2:
            return String(describing: CalculatedState.Cooking).uppercased()
        case .FlipFood:
            return "Flip\nFood"
        case .LidOpenDuringCook, .LidOpenBeforeCook:
            return "Close\nLid"
        case .Done:
            return "Complete".uppercased()
        default:
            return String(describing: state).uppercased()
        }
    }
    
    static func getDonenessDisplayString(doneness: Doneness?, food: Food?) -> String {
        guard let doneness = doneness else { return "" }
        // TODO: -
        switch food {
        case .NotSet, .Manual:
            return "Manual"
        default:
            switch doneness {
            case .Rare1:
                return "Rare 1"
            case .Rare2:
                return "Rare 2"
            case .MedRare3:
                return "Med Rare 3"
            case .MedRare4:
                return "Med Rare 4"
            case .Med5:
                return "Med 5"
            case .Med6:
                return "Med 6"
            case .MedWell7:
                return "Med Well 7"
            case .MedWell8:
                return "Med Well 8"
            case .Well9:
                return "Well 9"
            case .Unknown:
                return "Unknown"
            case .NotSet:
                return "NotSet"
            case .MedRare:
                return "Med Rare"
            case .Medium:
                return "Medium"
            case .MedWell:
                return "Med Well"
            case .Well:
                return "Well"
            default:
                return String(describing: doneness)
            }
        }
    }
    
    static func isCookingState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false}
        
        return  [
            CalculatedState.Preheating,
            CalculatedState.Cooking,
            CalculatedState.Resting,
            CalculatedState.Done,
            CalculatedState.AddFood,
            CalculatedState.FlipFood,
            CalculatedState.LidOpenBeforeCook,
            CalculatedState.LidOpenDuringCook,
            CalculatedState.PlugInProbe1,
            CalculatedState.PlugInProbe2,
            CalculatedState.GetFood,
            CalculatedState.Igniting
        ].contains(cookingState)
    }
    
    static func isPreCookState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false}
        
        return  [
            CalculatedState.Idle,
            CalculatedState.PoweredOff,
            CalculatedState.Offline,
            CalculatedState.NoGrills,
            CalculatedState.Updating,
            CalculatedState.Unknown
        ].contains(cookingState)
    }

    static func isUpdateState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false}
        
        return  [
            CalculatedState.Preheating,
            CalculatedState.Cooking,
            CalculatedState.AddFood,
            CalculatedState.FlipFood,
            CalculatedState.LidOpenBeforeCook,
            CalculatedState.LidOpenDuringCook,
            CalculatedState.PlugInProbe1,
            CalculatedState.PlugInProbe2,
            CalculatedState.Igniting
        ].contains(cookingState)
    }
    
    static func isPreheatState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false}
        
        return  [
            CalculatedState.Igniting,
            CalculatedState.Preheating,
            CalculatedState.AddFood,
        ].contains(cookingState)
    }
    
    static func isDoneState(state: CalculatedState?, cookType: CookType = .Timed) -> Bool {
        guard let cookingState = state else { return false }
        
        return cookType == .Timed ? [
                CalculatedState.GetFood,
                CalculatedState.Done
        ].contains(cookingState) :
        state == CalculatedState.Done
    }
    
    static func isShowTargetTempState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false }
        
        return  [
            CalculatedState.Resting,
            CalculatedState.GetFood,
            CalculatedState.Done
        ].contains(cookingState)
    }
    
    static func isOfflineState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false}
        
        return  [
            CalculatedState.PoweredOff,
            CalculatedState.Offline,
            CalculatedState.NoGrills,
            CalculatedState.Unknown
        ].contains(cookingState)
    }
    
    static func isSkipState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false }
        
        return [CalculatedState.Igniting, CalculatedState.Preheating].contains(cookingState)
    }
    
    static func isNotSetState(state: CalculatedState?) -> Bool {
        guard let cookingState = state else { return false }
        
        return [
            CalculatedState.Cooking,
            CalculatedState.FlipFood,
            CalculatedState.Resting
        ].contains(cookingState)
    }
    
    static func isDisabledThermometerMode(cookMode: CookMode?) -> Bool {
        guard let cookMode = cookMode else { return false }
        
        return disabledThermometerCookModes.contains(cookMode)
    }
    
    static func hasNoPreheat(cookMode: CookMode) -> Bool {
        return [CookMode.Broil, CookMode.Dehydrate].contains(cookMode)
    }
    
    static func isWoodfireEnabled(cookMode: CookMode, state: CalculatedState) -> Bool {
        return (cookMode == .Dehydrate && CookDisplayValues.isUpdateState(state: state))
        || (![CookMode.Broil, CookMode.Smoke].contains(cookMode) && [CalculatedState.Igniting, CalculatedState.Preheating].contains(state))
    }

    static func getPercentOfRange(range: [UInt], current: UInt) -> CGFloat {
        if range.count > 1 {
            let denominator = CGFloat(range[1]) - CGFloat(range[0])
            let numerator = CGFloat(current) - CGFloat(range[0])
            if denominator > 0, numerator > 0 {
                return (numerator / denominator) <= 1 ? (numerator / denominator) : 1
            }
        }
        return 0.0
    }

    static func roundSeconds(totalSeconds: Int, roundUp: Bool = false) -> Int {
        let seconds = totalSeconds % 60
        if (roundUp && seconds > 0) || seconds >= 30 {
            return totalSeconds + 60 - seconds
        }
        return totalSeconds - seconds
    }
}
