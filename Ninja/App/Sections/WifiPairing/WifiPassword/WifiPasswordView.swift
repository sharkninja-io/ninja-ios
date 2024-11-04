//
//  WifiPasswordView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class WifiPasswordView: BaseXIBView {
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordWrapper: PasswordWrapperView!
    @IBOutlet var noPasswordCheckbox: Checkbox!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        iconView.image = IconAssetLibrary.ico_wifi_full.asImage()
        titleLabel.text = "My Network"
        
        passwordWrapper.titleLabel.text = "PASSWORD"
        passwordWrapper.textField.placeholder = "Type your network password"
        noPasswordCheckbox.setTitle(" My network doesn't require a password", for: .normal)
        continueButton.setTitle("CONNECT", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingWifiItemLabel)
        titleLabel.textAlignment = .center
        passwordWrapper.setStyle(textFieldStyle: .passwordTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        noPasswordCheckbox.setStyle(.checkboxLeadingAlignedButton)
        continueButton.setStyle(.primaryButton)
    }
}
