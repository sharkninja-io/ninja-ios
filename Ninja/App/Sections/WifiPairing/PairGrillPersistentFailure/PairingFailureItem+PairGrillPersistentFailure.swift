//
//  PairingFailureItem.swift
//  Ninja
//
//  Created by Martin Burch on 12/12/22.
//

import Foundation

extension PairingFailureItem {
    
    static let persistentApplianceItems: [PairingFailureItem] = [
        PairingFailureItem(
            title: "Reset your Grill:",
            info: "Turn off your Grill presing the button."
        ),
        PairingFailureItem(
            title: "Reactivate Discoverable mode:",
            info: "Hold for tree seconds the mode button on the Grill."
        ),
    ]
    
}
