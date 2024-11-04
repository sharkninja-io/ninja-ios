//
//  NetworkingService.swift
//  Ninja
//
//  Created by Martin Burch on 4/10/23.
//

import Foundation
import Network
import Combine

struct NetworkingStatus {
    let isConnected: Bool
    let isCellular: Bool
}

class NetworkMonitorService {
    
    public static var shared: NetworkMonitorService = .init()
    
    private var monitor: NWPathMonitor
    var connectionSubject = CurrentValueSubject<NetworkingStatus?, Never>(nil)

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.connectionSubject.send(.init(isConnected: path.status == .satisfied, isCellular: path.isExpensive))
        }
    }
    
    func start() {
        monitor.start(queue: DispatchQueue.global(qos: .utility))
    }
    
    func stop() {
        monitor.cancel()
    }
}
