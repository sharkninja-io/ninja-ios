//
//  WifiTipsItem.swift
//  Ninja
//
//  Created by Martin Burch on 12/5/22.
//

import Foundation

struct WifiTipsItem {
    var title: String
    var description: String
    
    static var items: [WifiTipsItem] = [
        WifiTipsItem(
            title: "Reset Router",
            description: "Unplug the power cord from the wall (or the back of the router), wait 60 seconds, then plug it back in."
        ),
        WifiTipsItem(
            title: "Check Network Type",
            description: "Ninja devices only connect to 2.4GHz networks. Make sure your 2.4GHz network is not hidden or turned off. If you have an app for your router, use it to unhide or turn on your 2.4GHz network. Alternatively, contact your internet service provider."
        ),
        WifiTipsItem(
            title: "Other",
            description: "If you're having internet issues with other products in your home, contact your internet service provider."
        )
    ]
    
}
