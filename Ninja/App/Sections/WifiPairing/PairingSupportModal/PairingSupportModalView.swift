//
//  PairingModalView.swift
//  Ninja
//
//  Created by Martin Burch on 12/8/22.
//

import UIKit

class PairingSupportModalView: BaseView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
       return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    var customView: UIView? = nil
    
    var primaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setImage(IconAssetLibrary.ico_phone.asImage()?.tint(color: ColorThemeManager.shared.theme.primaryBackgroundColor), for: .normal)
        return button
    }()
    
    var secondaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    
    var viewStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    var titleStyle: LabelStyle = .pairingTitleLabel
    var descriptionStyle: LabelStyle = .pairingLargestInfoLabel
    var primaryButtonStyle: ButtonStyle = .primaryButton
    var secondaryButtonStyle: ButtonStyle = .secondaryButton
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Still having trouble?"
        primaryButton.setTitle("GIVE US A CALL", for: .normal)
        secondaryButton.setTitle("NEVERMIND", for: .normal)
    }
    
    internal func setDescriptionText() {
        descriptionLabel.attributedText = NSMutableAttributedString()
            .appendText("Get in touch with us by calling ", font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16), foregroundColor: ColorThemeManager.shared.theme.grey01)
            .appendText("1-855-427-5123", font: FontFamilyLibrary.gotham_bold.asFont(size: 16) ?? .systemFont(ofSize: 16), foregroundColor: ColorThemeManager.shared.theme.grey01)
        descriptionLabel.textAlignment = .center
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(titleStyle)
        titleLabel.textAlignment = .center
        descriptionLabel.setStyle(descriptionStyle) // 16,700,grey
        setDescriptionText()
        primaryButton.setStyle(primaryButtonStyle)
        secondaryButton.setStyle(secondaryButtonStyle)
    }
    
    override func setupConstraints() {
        viewStack.addArrangedSubview(titleLabel)
        viewStack.addArrangedSubview(descriptionLabel)
        if let customView = customView {
            viewStack.addArrangedSubview(customView)
        }
        viewStack.addArrangedSubview(primaryButton)
        viewStack.addArrangedSubview(secondaryButton)
        addSubview(viewStack)
        
        NSLayoutConstraint.activate([
            viewStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            viewStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            viewStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            viewStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
    }
}
