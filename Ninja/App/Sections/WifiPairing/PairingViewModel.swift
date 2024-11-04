//
//  PairingViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import Foundation
import Combine
import GrillCore

class PairingViewModel {
    
    enum PairingError {
        case UserDeniedHotspot
        case GrillHotspotConnectionFailed
        case GrillWifiConnectionError(Error)
    }
    
    private var hotspotDisposables = Set<AnyCancellable>()
    private var pairingDisposables = Set<AnyCancellable>()
    private lazy var hotspotService: DeviceHotspotService = .shared
    private lazy var pairingService: DevicePairingService = .shared
    private lazy var controlService: DeviceControlService = .shared
    
    var selectedIPAddressSubject: CurrentValueSubject<String?, Never> {
        get { hotspotService.gatewaySubject }
    }
    var deviceWifiNetworksSubject: CurrentValueSubject<[CloudCoreSDK.WifiNetwork], Never> {
        get { pairingService.wifiNetworksSubject }
    }
    var pairingStateSubject: CurrentValueSubject<CloudCoreSDK.WifiPairingState, Never> {
        get { pairingService.pairingStateSubject }
    }
    var pairingErrorSubject = PassthroughSubject<PairingError,Never>()
    
    var selectedWifiNetwork: CloudCoreSDK.WifiNetwork? = nil
    var _currentDeviceDSN: String? = nil
    var currentDeviceDSN: String? {
        get { _currentDeviceDSN }
    }
    var hotspotfailureCount: Int = 0
    var pairingFailureCount: Int = 0
    let supportNumber = "1-855-427-5123"
    var grillName: String? = "Ninja® Foodi® XL Pro" // TODO: CurrentValueSubject? / needed?
    
    private static var _instance: PairingViewModel = .init()
    static var shared: PairingViewModel {
        get { _instance }
    }
    
    private init() { }
    
    deinit {
        hotspotDisposables.removeAll()
        pairingDisposables.removeAll()
    }
    
    func subscribeToHotspotService() {
        hotspotDisposables.removeAll()
        hotspotService.errorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            switch error {
            case .userDenied:
                self?.pairingErrorSubject.send(.UserDeniedHotspot)
            case .unknown:
                self?.pairingErrorSubject.send(.GrillHotspotConnectionFailed)
            default:
                break
            }
        }.store(in: &hotspotDisposables)
    }
    
    func subscribeToPairingService() {
        pairingDisposables.removeAll()
        pairingService.resultSubject.receive(on: DispatchQueue.main).sink { [weak self] dsn in
            self?._currentDeviceDSN = dsn
        }.store(in: &pairingDisposables)
        pairingService.errorSubject.receive(on: DispatchQueue.main).sink { [weak self] error in
            Logger.Error(error)
            self?.pairingErrorSubject.send(.GrillWifiConnectionError(error))
        }.store(in: &pairingDisposables)
    }
    
    func startDeviceWifiHotspotScanning() {
        hotspotService.requestNEHotspotManagerPrompt(configuration: hotspotService.getDefaultConfiguration())
    }
    
    func cancelDeviceWifiHotspotScanning() {
        // TODO: cancel scan
        hotspotService.cancelHotspotManagerScan()
    }
    
    func disconnectDeviceWifiHotspot() {
        hotspotService.disconnectNEHotspot()
    }
    
    func setDeviceWifiNetwork(network: CloudCoreSDK.WifiNetwork) {
        pairingService.setWifiNetwork(network: network)
    }
    
    func startPairing() {
        if let selectedIPAddress = selectedIPAddressSubject.value {
            pairingService.startPairing(ipAddress: selectedIPAddress)
        }
    }
    
    func continuePairing() {
        pairingService.continuePairing()
    }
    
    func cancelPairing() {
        pairingService.cancelPairing()
    }
    
    func nameDevice(dsn: String, name: String) async -> Bool {
        guard !dsn.isEmpty, !name.isEmpty else { return false }
        // TODO: - check max length/characters etc.
        controlService.getDevices()
        grillName = await controlService.nameDevice(dsn: dsn, name: name)
        Logger.Debug("Device Name: \(String(describing: grillName))")
        return grillName != nil && !(grillName?.isEmpty ?? false)
    }
    
    func getGrillName() -> String? {
        return grillName
    }
}
