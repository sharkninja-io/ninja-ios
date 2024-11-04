//
//  CountryRegionManager.swift
//  SharkClean
//
//  Created by Jonathan on 1/11/22.
//

import UIKit

struct CountryRegionManager {
    
    public static var _instance: CountryRegionManager = .init(locale: Locale.current as NSLocale)
    
    public static var shared: CountryRegionManager {
        get { return _instance }
    }
 
    private var currentLocale: NSLocale?
    
    private var currentSelected: CountryRegionSupport?
    
    private var _countryRegionList: [CountryRegionSupport] = {
        var list: [CountryRegionSupport] = []
        for country in Country.ninjaSupportedCountries {
            list.append(.init(country.countryCode, name: country.localizedName, server: country.regionServer))
        }
        return list
    }()
    
    public var countryRegionList: [CountryRegionSupport] {
        get {
            return _countryRegionList
        }
    }
    
    private init(locale: NSLocale?) {
        self.currentLocale = locale
    }
    
    public mutating func generateSupportedCountryRegionList() {
        guard let currentLocale = currentLocale else { return }

        for (idx, cr) in _countryRegionList.enumerated() {
            let isCurrentLocale = cr.isCountryRegionCurrentLocale(locale: currentLocale)
            if isCurrentLocale == true {
                currentSelected = cr
                _countryRegionList.remove(at: idx)
            }
        }
        
        if let selected = currentSelected {
            _countryRegionList.sort()
            _countryRegionList.insert(selected, at: 0)
        }
        
        _countryRegionList.append(.init(.emptyOrNone, name: Localizable("36624dddae19ce59ff49b4f58e262b72be9307ad").value, server: .Unknown))
    }
    
    public func isCurrentLocalSelected() -> Bool {
        return currentSelected != nil
    }
    
    public func getCurrentSelectedLocale() -> CountryRegionSupport? {
        return currentSelected
    }
    
    public mutating func selectCurrentLocaleByChoice(_ selection: CountryRegionSupport) {
        self.currentSelected = selection
    }
    
    public func getLocale(_ code: String) -> CountryRegionSupport? {
        return countryRegionList.first { countryRegion in
            countryRegion.code == code
        }
    }
    
}
