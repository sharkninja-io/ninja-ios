//
//  PairingFailureItem.swift
//  Ninja
//
//  Created by Martin Burch on 12/12/22.
//

import Foundation

extension PairingFailureItem {
    
    static let persistentConnectionItems: [PairingFailureItem] = [
        PairingFailureItem(
            title: "Forgot password:",
            info: "Try checking the back of your router or contact someone who may know it."
       ),
        PairingFailureItem(
            title: "Server Issue:",
            info: "Make sure your network is not a VPN or proxy server."
       ),
        PairingFailureItem(
            title: "Other:",
            info: "If you’re having internet issues with other products in your home, contact your internet service provider. "
       ),
    ]
    
}
