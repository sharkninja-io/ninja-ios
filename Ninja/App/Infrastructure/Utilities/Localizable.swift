//
//  Localizable.swift
//  SharkClean
//
//  Created by Jonathan on 1/11/22.
//

import Foundation

struct Localizable {
    
    enum Supported: String {
        /// US English
        case EN = "en"
        /// Great Britain English
        case EN_GB = "en-GB"
        /// German or Deutsch
        case DE = "de"
        /// Spaniard Spanish
        case ES = "es"
        /// Latin America Spanish
        case ES_419 = "es-419"
        /// European French
        case FR = "fr"
        /// Canadian French
        case FR_CA = "fr-CA"
        /// Italian
        case IT = "it"
        /// Simplified Chinese
        case ZH_HANS = "zh-Hans"
        /// Japanese
        case JA = "ja"
    }

    private let key: String
    
    public let value: String
    
    /// Get the `Bundle` for English files to use if target language translation cannot be found.
    private static var ENG_BUNDLE: Bundle? {
        return Bundle(path: Bundle.main.path(forResource: Supported.EN.rawValue, ofType: "lproj") ?? "")
    }

    init(_ key: String) {
        guard key != "" else { fatalError("No key was passed or it's empty...") }
        self.key = key
        
        guard let ENG_BUNDLE = Self.ENG_BUNDLE else {
            self.value = NSLocalizedString(key, comment: "")
            return
        }
        
        // Default value to return if translation cannot be found
        let english = NSLocalizedString(key, bundle: ENG_BUNDLE, comment: "")
        
        self.value = NSLocalizedString(key, value: english, comment: "")
    }

    public func with(args: CVarArg...) -> String {
        return withVaList(args) { _ in
            let arguments = args.map { String(describing: $0) } as [CVarArg]
            return String(format: value, arguments: arguments)
        }
    }
    
    @discardableResult
    public static func locale() -> Supported {
        let locale = (Locale.current as NSLocale).languageCode
        Logger.Ui("Device Language::\(String(describing: locale))")
        return Supported(rawValue: locale) ?? .EN
    }
}
