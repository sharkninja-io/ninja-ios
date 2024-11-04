//
//  MonitorControlModalView.swift
//  Ninja
//
//  Created by Martin Burch on 3/9/23.
//

import UIKit

class MonitorControlModalView: BaseView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme } {
        didSet {
            setNeedsLayout()
        }
    }
    var primaryButtonStyle: ButtonStyle = .primaryButton
    
    var showSecondaryButton: Bool = true {
        didSet {
            if showSecondaryButton {
                viewStack.addArrangedSubview(secondaryButton)
            } else {
                secondaryButton.removeFromSuperview()
            }
            layoutIfNeeded()
        }
    }

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
        stack.backgroundColor = .clear
        return stack
    }()
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Title..."
        descriptionLabel.text = "Description ..."
        primaryButton.setTitle("Okay".uppercased(), for: .normal)
        secondaryButton.setTitle("Cancel".uppercased(), for: .normal)
    }
    
    override func refreshStyling() {
        backgroundColor = theme().modalBackground
        titleLabel.setStyle(.cookModalTitleLabel, theme: theme())
        descriptionLabel.setStyle(.cookModalDescriptionLabel, theme: theme()) // 16,700,grey
        
        primaryButton.setStyle(primaryButtonStyle, theme: theme())
        secondaryButton.setStyle(.transparentButton(foregroundColor: theme().primaryAccentColor), theme: theme())
    }
    
    override func setupConstraints() {
        viewStack.addArrangedSubview(titleLabel)
        viewStack.addArrangedSubview(descriptionLabel)
        if let customView = customView {
            viewStack.addArrangedSubview(customView)
        }
        viewStack.addArrangedSubview(primaryButton)
        if showSecondaryButton {
            viewStack.addArrangedSubview(secondaryButton)
        }
        addSubview(viewStack)
        
        NSLayoutConstraint.activate([
            viewStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            viewStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            viewStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            viewStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
    }
}
