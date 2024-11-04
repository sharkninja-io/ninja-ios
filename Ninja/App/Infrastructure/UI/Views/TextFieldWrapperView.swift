//
//  PasswordTextFieldView.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit
import SwiftUI

@IBDesignable
class TextFieldWrapperView: UIView {
    
    public var maxLength = 50 // TODO: //
    public var isValid: (String?) -> Bool = { _ in return true }
    
    @IBInspectable public var borderColor = UIColor.lightGray { // TODO: //
        didSet {
            layoutSubviews()
        }
    }
//    @IBInspectable public var errorColor = UIColor.red { // TODO: //
//        didSet {
//            layoutSubviews()
//        }
//    }
//    @IBInspectable public var errorMessage: String? = nil {
//        didSet {
//            layoutSubviews()
//        }
//    }
    @IBInspectable public var placeholder = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var clearImage: UIImage? { IconAssetLibrary.system_clear_fill.asSystemImage()?.tint(color: ColorThemeManager.shared.theme.secondaryTextColor) }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textField: UITextField = {
        let pw = UITextField()
        pw.translatesAutoresizingMaskIntoConstraints = false
        pw.textContentType = nil
        pw.isSecureTextEntry = false
        pw.placeholder = ""
        pw.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return pw
    }()
    
    var underLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.opacity = 0
        return label
    }()
    
    internal func truncateText() {
        textField.text = textField.text?.prefix(maxLength).description
    }
    
    public func isTextValid() -> Bool {
        return isValid(textField.text)
    }
    
    public func showMessage(message: String, color: UIColor? = nil, duration: TimeInterval = 0.5) {
        messageLabel.text = message
        UIView.animate(withDuration: duration) { [weak self] in
            if let color = color {
                self?.underLine.backgroundColor = color
                self?.messageLabel.textColor = color
            }
            self?.messageLabel.layer.opacity = 1.0
        }
    }
    
    public func hideMessage(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.underLine.backgroundColor = self?.borderColor
            self?.messageLabel.textColor = self?.borderColor
            self?.messageLabel.layer.opacity = 0
        }
    }
    
    internal func dontClearPlaceholderOnEdit() {
        textField.removeEvent(for: .editingDidBegin)
        textField.removeEvent(for: .editingDidEnd)
    }
    
    public func setStyle(textFieldStyle: TextFieldStyle = .defaultTextField, titleStyle: LabelStyle = .textFieldTitleLabel, messageStyle: LabelStyle = .textFieldMessageLabel, theme: ColorTheme = ColorThemeManager.shared.theme) {
        textField.setStyle(textFieldStyle, theme: theme)
        titleLabel.setStyle(titleStyle, theme: theme)
        messageLabel.setStyle(messageStyle, theme: theme)
        setPlaceholder(text: textField.placeholder ?? "", color: textFieldStyle.properties(theme).placeholderColor)
    }
    
    public func setPlaceholder(text: String, color: UIColor? = nil) {
        if let color = color ?? titleLabel.textColor {
            textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
        } else {
            textField.placeholder = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
        setupEvents()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let clearButton = textField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(clearImage, for: .normal)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 64)
    }
    
    internal func setupView() {
        self.backgroundColor = .clear
        titleLabel.textColor = borderColor
        underLine.backgroundColor = borderColor
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        messageLabel.textColor = borderColor
    }
    
    internal func setupEvents() {
        textField.onEvent(for: .editingDidBegin) { [weak self] textfield in
            guard let self = self else { return }
            
            self.textField.placeholder = ""
        }
        textField.onEvent(for: .editingDidEnd) { [weak self] textfield in
            guard let self = self else { return }
            
            self.textField.placeholder = self.placeholder
        }
    }
    
    internal func setupConstraints() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(underLine)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: underLine.topAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            underLine.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            underLine.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            underLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            underLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            underLine.heightAnchor.constraint(equalToConstant: 2),
            
            messageLabel.topAnchor.constraint(equalTo: underLine.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
}

extension TextFieldWrapperView: UITextFieldDelegate {  // default UITextFieldDelegate behaviour
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
