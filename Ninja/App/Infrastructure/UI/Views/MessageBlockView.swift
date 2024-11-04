//
//  MessageView.swift
//  Ninja
//
//  Created by Martin Burch on 11/18/22.
//

import UIKit

@IBDesignable
class MessageBlockView: BaseView {

    @IBInspectable
    var text: String = "." {
        didSet {
            messageLabel.text = text
        }
    }
    
    @IBInspectable
    var isError: Bool = true {
        didSet {
            setBlurbColors()
        }
    }
    
    var stackWrapper: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var zeroConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    private var blurbError: (UIColor, UIColor) {
        (ColorThemeManager.shared.theme.primaryErrorBackgroundColor, ColorThemeManager.shared.theme.primaryErrorForegroundColor)
    }
    
    private var blurbInfo: (UIColor, UIColor) {
        (ColorThemeManager.shared.theme.primaryAccentColor.withAlphaComponent(0.2), ColorThemeManager.shared.theme.primaryAccentColor)
    }
    
    func showMessage(duration: TimeInterval = 1) {
        zeroConstraint?.isActive = false
        bottomConstraint?.isActive = true
        UIView.animate(withDuration: duration) { [weak self] in
            self?.stackWrapper.layer.opacity = 1
        }
    }
    
    func hideMessage(duration: TimeInterval = 1) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.stackWrapper.layer.opacity = 0
        }) { [weak self] _ in
            self?.bottomConstraint?.isActive = false
            self?.zeroConstraint?.isActive = true
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.backgroundColor = .clear
        stackWrapper.layer.opacity = 0
        stackWrapper.layer.cornerRadius = 3
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        messageLabel.setStyle(.errorLabel)
        setBlurbColors()
    }
    
    func setBlurbColors() {
        stackWrapper.backgroundColor = isError ? blurbError.0 : blurbInfo.0
        messageLabel.textColor = isError ? blurbError.1 : blurbInfo.1
    }
    
    override func setupConstraints() {
        addSubview(stackWrapper)
        stackWrapper.addArrangedSubview(messageLabel)
        
        zeroConstraint = self.heightAnchor.constraint(equalToConstant: 0)
        zeroConstraint?.isActive = true
        bottomConstraint = stackWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomConstraint?.isActive = false
        
        NSLayoutConstraint.activate([
            stackWrapper.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            stackWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
