//
//  AppLocalNetworkPermissionsObserver.swift
//  Ninja
//
//  Created by Martin Burch on 12/13/22.
//

import Foundation
import Network
import Combine

class AppLocalNetworkPermissionsObserver: NSObject {
    
    private let SERVICE_DOMAIN: String = "local."
    private let SERVICE_TYPE: String = "_lnp._tcp."
    private let SERVICE_PORT: Int32 = 1100

    let permissionSubject = PassthroughSubject<Bool, Never>()
    
    private let netService: NetService
    private var intervalTimer: Timer?

    override init() {
        self.netService = .init(domain: SERVICE_DOMAIN, type: SERVICE_TYPE, name: String(describing: Self.self), port: SERVICE_PORT)
        super.init()
    }
    
    deinit {
        stopCheck()
    }
    
    func checkPermission(failureDelay: TimeInterval = 2) {
        netService.delegate = self
        self.netService.publish()
        intervalTimer = .scheduledTimer(withTimeInterval: failureDelay, repeats: false, block: { [weak self] timer in
            self?.stopCheck()
            self?.permissionSubject.send(false)
        })
    }
    
    private func stopCheck() {
        intervalTimer?.invalidate()
        netService.stop()
    }
}

extension AppLocalNetworkPermissionsObserver: NetServiceDelegate {
    func netServiceDidPublish(_ sender: NetService) {
        stopCheck()
        permissionSubject.send(true)
    }
}
