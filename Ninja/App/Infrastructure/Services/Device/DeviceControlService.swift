//
//  DeviceControlService.swift
//  Ninja
//
//  Created by Martin Burch on 12/13/22.
//

import Foundation
import GrillCore
import Combine

typealias Grill = GrillCoreSDK.Grill
typealias GrillManager = GrillCoreSDK.GrillManager

class DeviceControlService {
    
    private lazy var deviceBTControlService: DeviceBTControlService = .shared
    private lazy var notificationService: NotificationService = .shared

    let grillsSubject = CurrentValueSubject<[Grill]?, Never>(nil)
    let errorSubject = PassthroughSubject<CloudCoreSDK.Error, Never>()
    let currentGrillSubject = CurrentValueSubject<Grill?, Never>(nil)
    var currentStateSubject = CurrentValueSubject<GrillState?, Never>(nil)
    private var currentStateObserver: NSKeyValueObservation? = nil

    private static var _instance: DeviceControlService = .init()
    static var shared: DeviceControlService {
        get { _instance }
    }
    
    private init() { }
    
    func loadDevices() async {
        await GrillManager.shared.fetchGrills().onSuccess { [weak self] grills in
            self?.updateDevices(grills: grills)
        }.onFailure { error in
            if let err = error as? CloudCoreSDK.Error {
                errorSubject.send(err)
            } else {
                Logger.Error("FETCH GRILLS ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func getDevices() {
        updateDevices(grills: GrillManager.shared.grills)
    }
    
    func clearDevices() {
        self.stopMonitoring()
        
        currentStateSubject.send(nil)
        grillsSubject.send(nil)
        currentGrillSubject.send(nil)
    }
    
    func updateDevices(grills: [Grill]) {
        notificationService.allDsns = grills.map({ grill in grill.dsn })
        grillsSubject.send(grills)
        currentGrillSubject.send(GrillManager.shared.currentGrill)
        
        startMonitoring()
    }
    
    func getDevice(dsn: String) -> Grill? {
        return grillsSubject.value?.first {$0.dsn == dsn}
    }
    
    func setCurrentDevice(grill: Grill) {
        GrillCoreSDK.GrillManager.shared.currentGrill = grill
        currentGrillSubject.send(GrillCoreSDK.GrillManager.shared.currentGrill)
    }
    
    func nameDevice(dsn: String, name: String) async -> String? {
        if let grill = getDevice(dsn: dsn) {
            _ = await grill.setName(newName: name)
            return grill.getName()
        }
        return nil
    }
    
    func isWifiOnline(state: GrillState?) -> Bool {
        guard let state = state else { return false }
        return (!CookDisplayValues.isOfflineState(state: state.state) && state.connectedToInternet)
    }
    
    func isBTOnline(state: GrillState?) -> Bool {
        guard let state = state else { return false }
        return (!CookDisplayValues.isOfflineState(state: state.state) && state.connectedToBluetooth)
    }
    
    func isOnline(state: GrillState?) -> Bool {
        guard let state = state else { return false }
        return !CookDisplayValues.isOfflineState(state: state.state) && (state.connectedToInternet || state.connectedToBluetooth)
    }
    
    func isConnected(state: GrillState?) -> Bool {
        guard let state = state else { return false }
        return state.connectedToBluetooth || state.connectedToInternet
    }
    
    func startMonitoring() {
        if grillsSubject.value?.count ?? -1 > 0 {
            self.deviceBTControlService.start()
        }
        self.observeGrillState()
    }
    
    func stopMonitoring() {
        self.currentStateObserver?.invalidate()
        self.deviceBTControlService.stop()
    }
    
    private func observeGrillState() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.currentStateObserver?.invalidate()
            self.currentStateObserver = GrillManager.shared.observe(\.selectedGrillState, options: [.old, .new], changeHandler: { [weak self] _, change in
                guard let self = self else { return }
                
                if change.oldValue != change.newValue {
                    self.currentStateSubject.send(change.newValue)
                }
            })
        }
    }
    
}
