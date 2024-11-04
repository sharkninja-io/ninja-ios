//
//  BTWifiTipsItem.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/3/23.
//

import Foundation

struct BTWifiTipsItem {
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
