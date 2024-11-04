//
//  BTPairingViewModel.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/22/22.
//

import Foundation
import CoreBluetooth
import Combine

class BTPairingViewModel {
    
    // MARK: Services
    private lazy var btPairingService: DeviceBTPairingService = .shared
    private lazy var btControlService: DeviceBTControlService = .shared
    private lazy var controlService: DeviceControlService = .shared
    private lazy var pairingService: DevicePairingService = .shared
    
    // MARK: Subjects
    var btStateSubject: CurrentValueSubject<CBManagerState, Never> {
        get { btPairingService.connectionSubject }
    }
    var pairableGrillsSubject: CurrentValueSubject<[BTJoinableGrill], Never> {
        get { btPairingService.pairableGrillsSubject }
    }
    var selectedBluetoothUUIDSubject = CurrentValueSubject<String?, Never>(nil)
    var connectedBluetoothPeripheralSubject: CurrentValueSubject<BluetoothPeripheral?, Never> {
        get { btPairingService.connectedPeripheralSubject }
    }
    var connectedBluetoothPeripheralTokenSubject: CurrentValueSubject<String?, Never> {
        get { btPairingService.connectedPeripheralTokenSubject }
    }
    var connectedBluetoothPeripheralInfoSubject: CurrentValueSubject<BTLEInfo?, Never> {
        get { btPairingService.connectedPeripheralInfoSubject }
    }
    var peripheralConnectionSubject: PassthroughSubject<(BluetoothPeripheralConnectionState, CBPeripheral), Never> {
        get { btPairingService.peripheralConnectionSubject }
    }
    var deviceWifiNetworksSubject: CurrentValueSubject<[BTLEWifiNetwork], Never> {
        get { btPairingService.wifiNetworksSubject }
    }
    var deviceWifiStatusSubject: PassthroughSubject<BTLEWifiJoinStatus, Never> {
        get { btPairingService.wifiNetworkStatusSubject }
    }
    var apiPairingSubject: PassthroughSubject<String?, Never> {
        get { pairingService.resultSubject }
    }
    var errorSubject: PassthroughSubject<BTPairingError, Never> {
        get { btPairingService.errorSubject }
    }

    // MARK: Properties
    var selectedWifiNetwork: BTLEWifiNetwork? = nil
    var btSearchAttempts = 0
    var wifiFailureCount = 0
    let defaultGrillName = "Ninja ProConnect"
    var currentDeviceName = ""
    let maxNameLength = 15
    
    // MARK: Singleton
    private static var _instance: BTPairingViewModel = .init()
    static var shared: BTPairingViewModel { get { _instance } }
    
    private init() { }
    
    deinit { }

    // MARK: // Functions
    func connectToBluetooth() {
        Logger.Debug("BT_PAIRING: VM CONNECT TO BLUETOOTH")
        btPairingService.listenToPairing()
        btPairingService.connectToBluetooth()
    }
    
    func monitorAdvertisementData() {
        Logger.Debug("BT_PAIRING: VM INIT MONITOR ADVERTISEMENTS")
        btControlService.listenToAdvertisements()
    }
    
    func killAdvertisementMonitor() {
        Logger.Debug("BT_PAIRING: VM KILL MONITOR ADVERTISEMENTS")
        btControlService.stopListeningToAdvertisements()
    }
    
    func disconnectBluetooth() {
        Logger.Debug("BT_PAIRING: VM KILL BLUETOOTH")
        btPairingService.disconnectBluetooth()
    }
    
    func initializeBluetoothScan() {
        Logger.Debug("BT_PAIRING: VM CLEAR BLUETOOTH")
        btPairingService.initializeScan()
        selectedBluetoothUUIDSubject.send(nil)
    }
    
    func startScanForDevices() {
        Logger.Debug("BT_PAIRING: VM START DEVICE SCAN")
        btPairingService.startDeviceScan()
    }
    
    func stopScanForDevices() {
        Logger.Debug("BT_PAIRING: VM STOP DEVICE SCAN")
        btPairingService.stopDeviceScan()
    }
    
    func getPairableGrills() -> [BTJoinableGrill] {
        return pairableGrillsSubject.value
    }
    
    func connectToPeripheral(uuidString: String) {
        Logger.Debug("BT_PAIRING: VM CONNECT TO PERIPHERAL")
        if let peripheral = btPairingService.getPeripheral(uuidString: uuidString) {
            btPairingService.connectToDevice(peripheral: peripheral)
            // set default name on new device
            currentDeviceName = defaultGrillName
        } else {
            errorSubject.send(.InvalidUUID)
        }
    }
    
    func getDeviceInfo() {
        btPairingService.getConnectedDeviceInfo()
        Logger.Debug("BT_PAIRING: VM GET INFO")
    }
    
    func nameDevice(name: String, dsn: String) async {
        controlService.getDevices()
        let result = await controlService.nameDevice(dsn: dsn, name: name)
        Logger.Debug("DEVICE NAMED: \(String(describing: result))")
    }
    
    func registerDevice() async -> Bool {
        Logger.Debug("BT_PAIRING: VM REGISTER DEVICE...")
        if let dsn = connectedBluetoothPeripheralInfoSubject.value?.dsn,
           let token = connectedBluetoothPeripheralTokenSubject.value {
            Logger.Debug("BT_PAIRING: VM REGISTERING")
            await pairingService.registerDevice(dsn: dsn, token: token)
            Logger.Debug("BT_PAIRING: VM REGISTERED")
            return true
        }
        return false
    }

    func requestWifiNetworks() {
        Logger.Debug("BT_PAIRING: VM REQUEST WIFI")
        btPairingService.startWifiNetworkScan()
    }
    
    func stopRequestWifiNetworks() {
        Logger.Debug("BT_PAIRING: VM STOP REQUEST WIFI")
        btPairingService.stopWifiNetworkScan()
    }
    
    func connectToWifiNetwork(wifiNetwork: BTLEWifiNetwork) {
        Logger.Debug("BT_PAIRING: VM CONNECT WIFI")
        btPairingService.joinWifiNetwork(ssid: wifiNetwork.ssid ?? "", password: wifiNetwork.password ?? "")
    }
    
    func completePairing() {
        btPairingService.completeBluetoothPairing()
        selectedBluetoothUUIDSubject.send(nil)
        connectedBluetoothPeripheralInfoSubject.send(nil)
        selectedWifiNetwork = nil
        btSearchAttempts = 0
        wifiFailureCount = 0
        controlService.getDevices()
        Logger.Debug("BT_PAIRING: VM COMPLETED PAIRING")
    }
    
    func notifyDevicePaired(dsn: String) {
        btPairingService.completedSubject.send(dsn)
    }
    
    func userHasNoGrills() -> Bool {
        return GrillManager.shared.grills.count == 0
    }
}
