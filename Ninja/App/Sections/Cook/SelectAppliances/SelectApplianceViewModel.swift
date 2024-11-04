//
//  SelectApplianceViewModel.swift
//  Ninja
//
//  Created by Martin Burch on 2/9/23.
//

import Foundation
import Combine

class SelectApplianceViewModel {
    
    lazy var deviceService: DeviceControlService = .shared
    
    var grillsSubject: CurrentValueSubject<[Grill]?, Never> {
        get { deviceService.grillsSubject }
    }
    
    var currentGrillSubject: CurrentValueSubject<Grill?, Never> {
        get { deviceService.currentGrillSubject }
    }
    
    var currentStateSubject: CurrentValueSubject<GrillState?, Never> {
        get { deviceService.currentStateSubject }
    }
    
    private static var _instance: SelectApplianceViewModel = .init()
    static var shared: SelectApplianceViewModel {
        get { _instance }
    }
    
    private init() {}

    func setSelectedGrill(grill: Grill) {
        deviceService.setCurrentDevice(grill: grill)
    }
    
    func isDeviceOnWifi(state: GrillState?) -> Bool {
        return deviceService.isWifiOnline(state: state)
    }
    
    func isDeviceOnBT(state: GrillState?) -> Bool {
        return deviceService.isBTOnline(state: state)
    }
    
    func isDeviceOnline(state: GrillState?) -> Bool {
        return deviceService.isOnline(state: state)
    }
    
    func isDeviceConnected(state: GrillState?) -> Bool {
        return deviceService.isConnected(state: state)
    }
}
