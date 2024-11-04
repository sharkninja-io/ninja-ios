//
//  Logger.swift
//  SharkClean
//
//  Created by Jonathan Becerra on 5/15/22.
//

import Foundation

class Logger {
    
    private enum Event: String {
        case Debug = "🟢 [DEBUG]"
        case UI = "🔵 [UI]"
        case Warning = "🟡 [WARNING]"
        case Error = "🔴 [ERROR]"
    }
    
    private static var dateFormat = "yyyy-MM-dd hh:mm:ss"
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private init() {}
    
    // MARK: - Logging methods
    class func Debug(_ object: Any? = nil, filename: String = #file, line: Int = #line, funcName: String = #function) {
        print(event: .Debug, object: object, filename: filename, line: line, funcName: funcName)
    }
    
    class func Warning(_ object: Any? = nil, filename: String = #file, line: Int = #line, funcName: String = #function) {
        print(event: .Warning, object: object, filename: filename, line: line, funcName: funcName)
    }
    
    class func Error(_ object: Any? = nil, filename: String = #file, line: Int = #line, funcName: String = #function) {
        print(event: .Error, object: object, filename: filename, line: line, funcName: funcName)
    }
    
    class func Ui(_ object: Any? = nil, filename: String = #file, line: Int = #line, funcName: String = #function) {
        print(event: .UI, object: object, filename: filename, line: line, funcName: funcName)
   }
    
    private class func print(event: Event, object: Any? = nil, filename: String, line: Int, funcName: String) {
        #if DEBUG
            var text = "\(dateFormatter.string(from: Date())) \(event.rawValue)[\(sourceFileName(filePath: filename))]::L\(line)::\(funcName)"
            if let object = object {
               text += "::\(object)"
            }
            Swift.print(text)
            TestFairyService.shared.log(text)
        #endif
    }

    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!.replacingOccurrences(of: ".swift", with: "")
    }
}
