//
//  DeviceHotspotManager.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 4/1/22.
//

import Foundation
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import Combine

class DeviceHotspotService {
    
    public static let NINJA_SSID_PREFIX: String = "Ninja_CG"
    public static let DEFAULT_IP_MASK: String = "0.0.0.0"
    
    private static let NE_HOTSPOT_OS_RETRY_YIELD: Int = 3
    private static let NE_HOTSPOT_USER_RETRY_YIELD: TimeInterval = 2
    
    private var stopScan: Bool = true
    private var errorCount: Int = 0
    private var _currentSSID: String? = nil
    public var currentSSID: String? {
        get { _currentSSID }
    }
    
    public var errorSubject = PassthroughSubject<NEHotspotConfigurationError,Never>()
    public var gatewaySubject = CurrentValueSubject<String?,Never>(nil)
    
    private static var _instance: DeviceHotspotService = .init()
    public static var shared: DeviceHotspotService {
        get { return _instance }
    }
    
    private init() { }
    
    deinit {
        cancelHotspotManagerScan()
    }
    
    public func requestNEHotspotManagerPrompt(configuration: NEHotspotConfiguration) {
        self.stopScan = false
        NEHotspotConfigurationManager.shared.apply(configuration) { [weak self] error in
            guard let self = self else { return }
            if let error = (error as NSError?)?.code,
               let code = NEHotspotConfigurationError(rawValue: error) {
                Logger.Warning("Retry NECode: \(code.rawValue)")
                if code == .userDenied || self.errorCount >= 3 {
                    self.errorSubject.send(code)
                    self.cancelHotspotManagerScan()
                } else {
                    self.reattemptRequestNEHotspotManagerPrompt(configuration: configuration)
                }
                return
            }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                self._currentSSID = self.getNetworkSsid(prefix: Self.DEFAULT_IP_MASK)
                if let ssid = self._currentSSID {
                    Logger.Debug("SSID: \(ssid)")
                }
                let ipAddress = self.getDeviceIpAddress()
                if ipAddress.0 == Self.DEFAULT_IP_MASK && self.errorCount < 3 {
                    Logger.Warning("FGRoute Retry")
                    self.reattemptRequestNEHotspotManagerPrompt(configuration: configuration)
                    return
                }
                
                guard error == nil else {
                    return
                }

                self.gatewaySubject.send(ipAddress.0)
                self.cancelHotspotManagerScan()
            }
        }
    }
    
    private func reattemptRequestNEHotspotManagerPrompt(configuration: NEHotspotConfiguration) {
        DispatchQueue.global(qos: .background).asyncAfter(
            deadline: .now() + Self.NE_HOTSPOT_USER_RETRY_YIELD
        ) { [weak self] in
            guard let self = self else { return }
            if !self.stopScan {
                self.errorCount += 1
                self.requestNEHotspotManagerPrompt(configuration: configuration)
            }
        }
    }
    
    public func cancelHotspotManagerScan() {
        stopScan = true
        errorCount = 0
    }
    
    public func getDefaultConfiguration(ssidPrefix: String = NINJA_SSID_PREFIX) -> NEHotspotConfiguration {
        let hotspotConfiguration = NEHotspotConfiguration(ssidPrefix: ssidPrefix)
        hotspotConfiguration.joinOnce = true
        hotspotConfiguration.lifeTimeInDays = 1
        return hotspotConfiguration
    }
    
    private func getNetworkSsid(prefix: String) -> String? {
        if let supportedInterfaces = CNCopySupportedInterfaces() as? [String] {
            return supportedInterfaces.compactMap({
                if let info = CNCopyCurrentNetworkInfo($0 as CFString) as? [String: AnyObject],
                   let ssid = info[kCNNetworkInfoKeySSID as String] as? String,
                   ssid.starts(with: prefix) {
                    return ssid
                }; return nil
            }).first
        }; return nil
    }

    private func getCurrentNetworkSSID() async -> String? {
        return await withCheckedContinuation { continuation in
            NEHotspotNetwork.fetchCurrent { network in
                continuation.resume(returning: network?.ssid)
            }
        }
    }
    
    public func disconnectNEHotspot() {
        gatewaySubject.send(nil)
        if let currentSSID = currentSSID {
            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: currentSSID)
        }
    }
    
    private func getDeviceIpAddress(hasGateway: Bool = false, count: Int = 0, retryCount: Int = NE_HOTSPOT_OS_RETRY_YIELD) -> (String, String) {
        if count >= retryCount {
            return (Self.DEFAULT_IP_MASK, Self.DEFAULT_IP_MASK)
        }

        let gatewayIPAddress = FGRoute.getGatewayIP()
        let ipAddress = FGRoute.getIPAddress()
        if let ipAddress = ipAddress {
            if !hasGateway, let gatewayFromIPAddress = getGatewayFromIp(ipAddress: ipAddress) {
                Logger.Debug("Gateway: \(gatewayFromIPAddress) DEVICE: \(ipAddress)")
                return (gatewayFromIPAddress, ipAddress)
            } else if let gatewayIPAddress = gatewayIPAddress {
                Logger.Debug("Gateway: \(gatewayIPAddress) DEVICE: \(ipAddress)")
                return (gatewayIPAddress, ipAddress)
            }
        }
        
        Thread.sleep(forTimeInterval: 1.0)
        return getDeviceIpAddress(hasGateway: hasGateway, count: count + 1, retryCount: retryCount)
    }
    
    private func getGatewayFromIp(ipAddress: String) -> String? {
        var components = ipAddress.components(separatedBy: ".")
        if components.count == 4 {
            components.removeLast()
            components.append("1")
            return components.joined(separator: ".")
        }
        return nil
    }
}
