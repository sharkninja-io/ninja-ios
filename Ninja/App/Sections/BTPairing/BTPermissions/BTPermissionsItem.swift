//
//  BTPermissionsItem.swift
//  Ninja
//
//  Created by Rahul Sharma on 12/23/22.
//

import Foundation

struct BTPermissionsItem {
    static let items: [BTPermissionsItem] = [
        BTPermissionsItem(
            title: "Enable Bluetooth",
            description: "Allow access and make sure it is turned on",
            isImportant: false
        ),
    ]
        
    var title: String
    var description: String
    var isImportant: Bool?
}
