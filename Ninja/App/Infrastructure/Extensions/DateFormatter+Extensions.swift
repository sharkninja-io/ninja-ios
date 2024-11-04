//
//  Decoder-.swift
//  SharkRobot
//
//  Created by Takahiro Ninomiya on 6/28/20.
//  Copyright © 2020 SharkNinja. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var CODABLE: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    static var CODABLE_YYYY_MM_DD: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
}
