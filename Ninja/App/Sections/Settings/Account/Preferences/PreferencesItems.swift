//
//  PreferencesItem.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/10/22.
//

import Foundation

enum PreferencesItem: String, CaseIterable, SimplePickerDelegate {
    case weightUnit = "WEIGHT UNIT"
    case temperatureUnit = "TEMPERATURE UNIT"
    
    /// Title for the pickerview modal
    var modalTitle: String {
        return self.rawValue
    }
    
    /// An array of the possible pickerView choices for the preference.
    var choices: [String] {
        switch self {
        case .weightUnit:
            return SettingsViewModel.WeightUnitPreference.allCases.map({ $0.localizaedName })
        case .temperatureUnit:
            return SettingsViewModel.TemperatureUnitPreference.allCases.map({ $0.withTemperatureSymbol })
        }

    }
    
    /// Retrieves the user's saved preference from the viewModel.
    func savedPreference() -> String {
        let vm = SettingsViewModel.shared()
        
        switch self {
        case .weightUnit:
            return vm.weightUnit.rawValue
        case .temperatureUnit:
            return vm.temperatureUnit.withTemperatureSymbol
        }
    }
    
    /// The array index for the currently saved preference. Used to have the pickerview selection default to the current choice.
    var initialRow: Int {
        switch self {
        case .weightUnit:
            return SettingsViewModel.WeightUnitPreference.allCases.firstIndex(of: SettingsViewModel.WeightUnitPreference(rawValue: self.savedPreference()) ?? .pounds)!
        case .temperatureUnit:
            return SettingsViewModel.TemperatureUnitPreference.allCases.firstIndex(where: {$0.withTemperatureSymbol == self.savedPreference()}) ?? 0
        }
    }
    
    /// Save the selected choice to the viewModel
    func setItemProperty(_ property: String) {
        let vm = SettingsViewModel.shared()
        
        switch self {
        case .weightUnit:
            guard let unit = SettingsViewModel.WeightUnitPreference.allCases.first(where: {$0.localizaedName == property}) else {
                Logger.Error("Provided weight unit was not found. Defaulting to pounds")
                vm.setWeightUnitPreference("pounds")
                return
            }
            vm.setWeightUnitPreference(unit.rawValue)
        case .temperatureUnit:
            vm.setTemperatureUnitPreference("\(property.dropFirst())")
        }
    }
}
