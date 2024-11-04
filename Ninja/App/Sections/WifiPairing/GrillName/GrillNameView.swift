//
//  GrillNameView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class GrillNameView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var textFieldWrapper: TextFieldWrapperView!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Let's give your Ninja Grill a name"
        infoLabel.text = "Give your Ninja appliance a name."
        textFieldWrapper.titleLabel.text = "CHOOSE A NAME"
        // TODO: - set textField length
        continueButton.setTitle("CONTINUE", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        infoLabel.setStyle(.pairingLargestInfoLabel)
        textFieldWrapper.setStyle(textFieldStyle: .defaultTextField, titleStyle: .textFieldTitleLabel, messageStyle: .textFieldMessageLabel)
        continueButton.setStyle(.primaryButton)
    }
}
