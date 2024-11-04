//
//  DevicePairingService.swift
//  Ninja
//
//  Created by Martin Burch on 11/29/22.
//

import Foundation
import Combine
import GrillCore

class DevicePairingService {
    
    let pairingStateSubject = CurrentValueSubject<CloudCoreSDK.WifiPairingState, Never>(.Idle)
    let wifiNetworksSubject = CurrentValueSubject<[CloudCoreSDK.WifiNetwork], Never>([])
    let resultSubject = PassthroughSubject<String?, Never>()
    let errorSubject = PassthroughSubject<Error, Never>()
    
    private static var _instance: DevicePairingService = .init()
    static var shared: DevicePairingService {
        get { _instance }
    }
    
    private init() {
        listenToPairing()
    }
    
    private func listenToPairing() {
        GrillCoreSDK.WifiManager.stateCallback = { [weak self] state in
            self?.pairingStateSubject.send(state)
        }
        GrillCoreSDK.WifiManager.wifiNetworksCallback = { [weak self] networks in
            self?.wifiNetworksSubject.send(networks)
            self?.writeToLog(text: "Step Four: \(Date())::\(#function)")
        }
        GrillCoreSDK.WifiManager.resultCallback = { [weak self] result in
            result.onSuccess { dsn in
                self?.resultSubject.send(dsn)
                self?.writeToLog(text: "Step Six Success: \(dsn) \(Date())::\(#function)")
            }.onFailure { [weak self] error in
                self?.errorSubject.send(error)
                self?.resultSubject.send(nil)
                self?.writeToLog(text: "Step Six Failure: \(Date())::\(#function)")
            }
        }
    }
    
    func startPairing(ipAddress: String) {
        Task {
            await GrillCoreSDK.WifiManager.startPairing(ipAddress: ipAddress)
            writeToLog(text: "Step Three: \(Date())::\(#function)")
        }
    }
    
    func setWifiNetwork(network: CloudCoreSDK.WifiNetwork) {
        GrillCoreSDK.WifiManager.setNetwork(network: network)
        writeToLog(text: "Step Five: \(Date())::\(#function)")
    }
    
    /// Continue restarts the process from the last state/step
    func continuePairing() {
        Task {
            await GrillCoreSDK.WifiManager.continuePairing()
        }
    }
    
    func cancelPairing() {
        Task {
            await GrillCoreSDK.WifiManager.cancelPairing()
            wifiNetworksSubject.send([])
        }
    }
    
    func registerDevice(dsn: String, token: String) async {
        self.writeToLog(text: "Step Six Begin: \(dsn):\(token) \(Date())::\(#function)")
        await GrillCoreSDK.WifiManager.registerDevice(dsn: dsn, setupToken: token)
    }
        
    func writeToLog(text: String) {
        GrillCoreSDK.WifiManager.writeToPairingLog(text)
    }
    
    func readFromLog() async -> String {
        return GrillCoreSDK.WifiManager.readPairingLog().unwrapOrFallback(fallback: "")
    }
}
