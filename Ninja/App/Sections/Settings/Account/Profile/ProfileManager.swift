//
//  ProfileManager.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/14/22.
//

import Foundation
import UIKit

public enum ProfileManager: String, CaseIterable {
    case firstName = "First"
    case lastName = "Last Name"
    case address1 = "Address 1"
    case address2 = "Address 2"
    case city = "City"
    case state = "State / Province"
    case postalCode = "Zip Code"
    case phoneNumber = "Phone Number"
    
    /// Number of rows for the tableView
    ///
    /// The section needs one row per field, plus one more for the "Delete Account" cell. Thus, for countries that are not using a "State/Province" field, this will be the same as `ProfileManager.allCases.count`
    static var numberOfRowsInSection: Int {
        let includeSubregionField = Country.current == .UnitedStates || Country.current == .Canada
        return ProfileManager.allCases.count + (includeSubregionField ? 1 : 0)
    }
    
    /// An array of `ProfileManager` containing the appropriate cases based on the user's region.
    static var relevantCases: [ProfileManager] {
        if Country.current == .UnitedStates || Country.current == .Canada {
            return ProfileManager.allCases
        } else {
            return [.firstName, .lastName, .address1, .address2, .city, .postalCode, .phoneNumber]
        }
    }
    
    var isRequired: Bool {
        switch self {
        case .firstName, .lastName, .address1, .city, .state, .postalCode:
            return true
        case .address2, .phoneNumber:
            return false
        }
    }
    
    var titleText: String { return self.isRequired ? rawValue.uppercased() + "*" : rawValue.uppercased() }
    
    /// Icon for the trailing edge of the cell
    var auxiliaryImage: UIImage {
        switch self {
        case .state:
            return UIImage(systemName: "chevron.down") ?? UIImage()
        default:
            return IconAssetLibrary.ico_edit_pencil.asImage() ?? UIImage()
        }
    }
    
    var textContentType: UITextContentType? {
        switch self {
        case .firstName:
            return .givenName
        case .lastName:
            return .familyName
        case .address1:
            return .streetAddressLine1
        case .address2:
            return .streetAddressLine2
        case .city:
            return .addressCity
        case .state:
            return .addressState
        case .postalCode:
            return .postalCode
        case .phoneNumber:
            return .telephoneNumber
        }
    }
    
    /// The corresponding value saved in the Profile model. Will be an empty string is none is present.
    var storedValue: String {
        var fieldValue: String? = .emptyOrNone
        let model = SettingsViewModel.shared().userProfileDraft
        switch self {
        case .firstName:
            fieldValue = model?.firstName
        case .lastName:
            fieldValue = model?.lastName
        case .address1:
            fieldValue = model?.preferredShipToAddress?.addressLine1
        case .address2:
            fieldValue = model?.preferredShipToAddress?.addressLine2
        case .city:
            fieldValue = model?.preferredShipToAddress?.city
        case .state:
            if let state = Country.USRegions(rawValue: model?.preferredShipToAddress?.state ?? "") {
                fieldValue = state.localizedName
            } else if let province = Country.CanadaRegions(rawValue: model?.preferredShipToAddress?.state ?? "") {
                fieldValue = province.localizedName
            } else {
                break
            }
        case .postalCode:
            fieldValue = model?.preferredShipToAddress?.postalCode
        case .phoneNumber:
            fieldValue = model?.phoneHome
        }
        return fieldValue ?? .emptyOrNone
    }
    
    /// The closure to execute upon changing the textfield's value.
    var updateLocalModel: ((String) -> ()) {
        let vm = SettingsViewModel.shared()
        
        switch self {
        case .firstName:
            return { updatedField in vm.userProfileDraft?.firstName = updatedField }
        case .lastName:
            return { updatedField in vm.userProfileDraft?.lastName = updatedField }
        case .address1:
            return { updatedField in
                vm.userProfileDraft?.preferredShipToAddress?.street = updatedField
                vm.userProfileDraft?.preferredShipToAddress?.addressLine1 = updatedField
            }
        case .address2:
            return { updatedField in vm.userProfileDraft?.preferredShipToAddress?.addressLine2 = updatedField}
        case .city:
            return { updatedField in vm.userProfileDraft?.preferredShipToAddress?.city = updatedField }
        case .state:
            return { updatedField in
                if let state = Country.USRegions.allCases.first(where: { $0.localizedName == updatedField }) {
                    vm.userProfileDraft?.preferredShipToAddress?.state = state.rawValue
                } else if let province = Country.CanadaRegions.allCases.first(where: { $0.localizedName == updatedField }) {
                    vm.userProfileDraft?.preferredShipToAddress?.state = province.rawValue
                } else {
                    Logger.Error("State field updated with invalid value.")
                    MixpanelService.shared.trackSectionError(.DebugEvent, event: "ProfileRegistration", errorDescription: "State field updated with an invalid value: \(updatedField)")
                }
            }
        case .postalCode:
            return { updatedField in vm.userProfileDraft?.preferredShipToAddress?.postalCode = updatedField }
        case .phoneNumber:
            return { updatedField in vm.userProfileDraft?.phoneHome = updatedField }
        }
    }
}

// MARK: Picker Delegate
extension ProfileManager: SimplePickerDelegate {
    var modalTitle: String {
        guard self == .state else { return .emptyOrNone }
        return self.rawValue
    }
    
    var choices: [String] {
        guard self == .state else { return [] }
        if Country.current == .Canada {
            return Country.CanadaRegions.allCases.map({ $0.localizedName })
        } else {
            return Country.USRegions.allCases.map({ $0.localizedName })
        }
    }
    
    var initialRow: Int {
        guard self == .state else { return 0 }
        let isCA = Country.current == .Canada
        var savedRow: Int = 0
        
        if isCA {
            let region = Country.CanadaRegions(rawValue: SettingsViewModel.shared().userProfileDraft?.preferredShipToAddress?.state ?? "")
            savedRow = Country.CanadaRegions.allCases.firstIndex(of: region ?? .Alberta) ?? 0
        } else {
            let region = Country.USRegions(rawValue: SettingsViewModel.shared().userProfileDraft?.preferredShipToAddress?.state ?? "")
            savedRow = Country.USRegions.allCases.firstIndex(of: region ?? .Alaska) ?? 0
        }
        
        return savedRow
    }
}

// MARK: PhoneNumber Delegate
class ProfilePhoneNumberTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var country: Country
    
    init(country: Country) {
        self.country = country
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)

        let isFromAutoFill: Bool = newString.count - text.count > 1
        let phoneNumber = PhoneNumberManager.format(phone: newString, country: country, isFromAutoFill: isFromAutoFill)
        textField.text = phoneNumber
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        ProfileManager.phoneNumber.updateLocalModel(text)
    }
}
