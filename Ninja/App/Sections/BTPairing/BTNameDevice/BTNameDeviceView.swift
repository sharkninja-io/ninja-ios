//
//  BTNameDeviceView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/28/22.
//

import UIKit

class BTNameDeviceView: BaseXIBView {
    
    // IB Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameTextWrapper: TextFieldWrapperView!
    @IBOutlet var continueButton: UIButton!
    
    // Textfield Right View
    var characterCount: Int = 0 {
        didSet {
            countLabel.text = "\(characterCount)/15"
        }
    }
    @UsesAutoLayout var editImage = UIImageView(image: .init(systemName: "square.and.pencil")?.tint(color: .black))
    @UsesAutoLayout private var countLabel = UILabel()
    lazy var countStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [countLabel, editImage])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        return stack
    }()
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Do you want to pick a cool name for me?"
        nameTextWrapper.titleLabel.text = "Choose A Name".uppercased()
        continueButton.setTitle("No thanks, continue".uppercased(), for: .normal)
        
        nameTextWrapper.textField.rightViewMode = .always
        nameTextWrapper.textField.rightView = countStack
        // TODO: Hopefully delete this when we talk Design team into not having that edit image.
        nameTextWrapper.textField.onEvent(for: .editingDidBegin) { [weak self] _ in
            self?.editImage.removeFromSuperview()
        }
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingTitleLabel)
        countLabel.setStyle(.pairingInfoLabel)
        continueButton.setStyle(.primaryButton)
    }
    
    func showNameTooLongMessage() {
        nameTextWrapper.showMessage(message: "Name must be 15 characters or less", color: ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    func hideMessage() {
        nameTextWrapper.hideMessage()
    }
    
    func updateName() {
        if let text = nameTextWrapper.textField.text, text.count > 0 {
            characterCount = text.count
            continueButton.setTitle("Continue".uppercased(), for: .normal)
        } else {
            characterCount = nameTextWrapper.placeholder.count
            continueButton.setTitle("No thanks, continue".uppercased(), for: .normal)
        }
    }
}
