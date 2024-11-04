//
//  ProfileTextFieldCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/14/22.
//

import UIKit

class ProfileTextFieldCell: BaseTableViewCell {
    
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var textField = UITextField()
    @UsesAutoLayout private var icon = UIImageView()
    @UsesAutoLayout private var divider = UIView()
    @UsesAutoLayout var messageLabel = UILabel()
    
    public var updateField: ((String) -> ())?
    
    weak var parentProfileVC: ProfileViewController?
    
    var profileItem: ProfileManager?
    var preferencesItem: PreferencesItem?
    var textCountWhenBeginEditing: Int = 0
    
    private let chevronImage = UIImage(systemName: "chevron.down") ?? UIImage()
    
    override func setupViews() {
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(icon)
        contentView.addSubview(divider)
        contentView.addSubview(messageLabel)
        
        messageLabel.layer.opacity = 0
        
        icon.contentMode = .scaleAspectFit
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            textField.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: DefaultSizes.trailingPadding),
            textField.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -8),
            
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -46),
            icon.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            messageLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            messageLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.itemLabel)
        textField.font = FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16)
        textField.textColor = ColorThemeManager.shared.theme.primaryTextColor
        messageLabel.setStyle(.textFieldMessageLabel)
        
        icon.tintColor = ColorThemeManager.shared.theme.primaryForegroundColor
        divider.backgroundColor = ColorThemeManager.shared.theme.primaryForegroundColor
    }
    
    
    private func showMessage(message: String = "Field required", color: UIColor? = ColorThemeManager.shared.theme.primaryErrorForegroundColor, duration: TimeInterval = 0.5) {
        messageLabel.text = message
        UIView.animate(withDuration: duration) {
            if let color = color {
                self.divider.backgroundColor = color
                self.messageLabel.textColor = color
            }
            self.messageLabel.layer.opacity = 1.0
        }
    }
    
    private func hideMessage(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            self.divider.backgroundColor = ColorThemeManager.shared.theme.primaryForegroundColor
            self.messageLabel.textColor = ColorThemeManager.shared.theme.secondaryTextColor
            self.messageLabel.layer.opacity = 0
        }
    }
    
    
    /// Populate with parameters for profile registration
    public func connectData(withProfileItem item: ProfileManager, parent: ProfileViewController? = nil) {
        profileItem = item
        parentProfileVC = parent
        
        // Static items
        titleLabel.text = item.titleText
        icon.image = item.auxiliaryImage
        
        // Textfield
        if item.storedValue != .emptyOrNone {
            textField.text = item.storedValue
        } else {
            textField.placeholder = item.rawValue
        }
        
        if let contentType = item.textContentType {
            textField.textContentType = contentType
        }
        
        updateField = item.updateLocalModel
        
        // Setup Textfield
        if item == .state { // Disable textfield for State/Province so it can use a picker.
            textField.isUserInteractionEnabled = false
            return
        }
        
        textField.onEvent(for: .editingChanged) { [weak self] _ in
            guard let self else { return }
            let text = self.textField.text ?? .emptyOrNone
            if item == .phoneNumber {
                let country = Country.current
                if let code = country.phoneNumberCountryCode {
                    self.textField.text = "+\(code)"
                }
            }
            self.updateField?(text)
        }
        textField.onEvent(for: .editingDidEnd) { [weak self] _ in
            guard let self, let item = self.profileItem, item.isRequired else { return }
            if self.textField.text == .emptyOrNone {
                self.showMessage()
            } else {
                self.hideMessage()
            }
        }
    }
    
    /// Populate with parameters for preference settings
    public func connectData(_ item: PreferencesItem) {
        titleLabel.text = item.rawValue
        textField.text = item.savedPreference()
        icon.image = chevronImage
        
        textField.isUserInteractionEnabled = false
    }
}

extension ProfileTextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
