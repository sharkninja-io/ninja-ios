//
//  HapticService.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/4/22.
//

import Foundation
import CoreHaptics

class HapticService {
    enum StopType {
        case Stop
        case NotifyStop
        case Continue
    }
    
    private let hapticEngine: CHHapticEngine
    
    private static var _instance: HapticService? = .init()
    
    static func shared() -> HapticService? {
        return _instance
    }
    
    private init?() {
        let hapticCapabilities = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapabilities.supportsHaptics else { return nil }
        
        do {
            hapticEngine = try CHHapticEngine()
            hapticEngine.isAutoShutdownEnabled = true
        } catch let error {
            print("HAPTIC SERVICE: ENNGINE ERROR: \(error)")
            return nil
        }
    }
    
    func simpleBurst(intensity: Float,
                     sharpness: Float,
                     delay: TimeInterval = 0,
                     duration: TimeInterval = -1) -> CHHapticPattern? {
        do {
            let slice = (duration < 0) ?
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                ],
                relativeTime: delay)
            : CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                ],
                relativeTime: delay,
                duration: duration)
            return try CHHapticPattern(events: [slice], parameters: [])
        } catch let error {
            print("HAPTIC SERVICE: PATTERN ERROR: \(error)")
            return nil
        }
    }
    
    func playPattern(_ pattern: CHHapticPattern?, stopType: StopType = .NotifyStop) {
        guard let pattern = pattern else { return }
        do {
            try hapticEngine.start()
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            switch stopType {
                case .NotifyStop:
                    hapticEngine.notifyWhenPlayersFinished { _ in
                        return .stopEngine
                    }
                case .Stop:
                    try player.stop(atTime: CHHapticTimeImmediate)
                case .Continue:
                    break
            }
        } catch let error {
            print("HAPTIC SERVICE: PLAY ERROR: \(error)")
        }
    }
}
