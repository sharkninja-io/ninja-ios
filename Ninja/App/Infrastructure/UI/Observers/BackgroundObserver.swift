//
//  BackgroundObserver.swift
//  Ninja
//
//  Created by Martin Burch on 11/1/22.
//

import UIKit

class BackgroundObserver {
    private var onResignActive: (() -> Void)?
    private var onEnterForeground: (() -> Void)?
    
    init(_ onResignActive: (() -> Void)? = nil, _ onEnterForeground: (() -> Void)? = nil) {
        self.onResignActive = onResignActive
        self.onEnterForeground = onEnterForeground
    }
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func stop() {
        // TODO: - removes all observers
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appWillResignActive() {
        onResignActive?()
    }
    
    @objc func appWillEnterForeground() {
        onEnterForeground?()
    }
}
