//
//  CacheService.swift
//  SharkClean
//
//  Created by Jonathan on 1/24/22.
//

import Foundation
import GrillCore

struct CacheService {
    
    internal let dateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"

    enum Container {
        case User
        case Appliance(String)
        case Logging
        case App
        
        var path: String {
            switch self {
            case .User:
                return "user"
            case .Appliance(let dsn):
                return dsn
            case .Logging:
                return "logging"
            case .App:
                return "app"
            }
        }
    }
    
    private static var _service: CacheService = {
        let stateMachine = CacheService()
        return stateMachine
    }()
    
    public static func shared() -> CacheService {
        return _service
    }
    
    private init() {}
    
    public func set(_ container: Container, key: String, data: CloudCoreSDK.CacheDataValues) {
        let result = GrillCoreSDK.Cache.setCachedData(path: container.path, key: key, data: data)
        result.onFailure { error in
            Logger.Error(error)
        }
    }
    
    public func get(_ container: Container, key: String) -> CloudCoreSDK.CacheDataValues {
        let result = GrillCoreSDK.Cache.getCachedData(path: container.path, key: key)
        var value: CloudCoreSDK.CacheDataValues = .Null
        result.onSuccess { cache in
            value = cache
        }.onFailure { error in
            Logger.Error(error)
        }
        return value
    }
}
