//
//  TextFieldStyle.swift
//  Ninja
//
//  Created by Martin Burch on 9/13/22.
//

import UIKit

struct TextFieldStyle {
    var properties: (ColorTheme) -> TextFieldStyleProperties
}

struct TextFieldStyleProperties {
    var backgroundColor: UIColor?
    var background: UIImage?
    var disabledBackground: UIImage?
    var font: UIFont
    var textColor: UIColor?
    var textAlignment: NSTextAlignment
    var placeholderColor: UIColor?
    var borderStyle: UITextField.BorderStyle
    var borderColor: UIColor
    var borderWidth: CGFloat
    var cornerRadius: CGFloat
    var textContentType: UITextContentType?
    var keyboardType: UIKeyboardType
    var autocapitalizationType: UITextAutocapitalizationType
    var autocorrectionType: UITextAutocorrectionType
    
    init(
        backgroundColor: UIColor? = .clear,
        background: UIImage? = nil,
        disabledBackground: UIImage? = nil,
        font: UIFont = .systemFont(ofSize: 14),
        textColor: UIColor? = ColorThemeManager.shared.theme.primaryTextColor,
        textAlignment: NSTextAlignment = .left,
        placeholderColor: UIColor? = ColorThemeManager.shared.theme.tertiaryTextColor,
        borderStyle: UITextField.BorderStyle = .none,
        borderColor: UIColor = .clear,
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = 0,
        textContentType: UITextContentType? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        autocorrectionType: UITextAutocorrectionType = .no
    ) {
        self.backgroundColor = backgroundColor
        self.background = background
        self.disabledBackground = disabledBackground
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.placeholderColor = placeholderColor
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.textContentType = textContentType
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
    }
}

extension TextFieldStyle {
    static var defaultTextField = TextFieldStyle { theme in
        TextFieldStyleProperties()
    }
    static var emailTextField = TextFieldStyle { theme in
        TextFieldStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textContentType: .emailAddress,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no
        )
    }
    static var passwordTextField = TextFieldStyle { theme in
        TextFieldStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            textContentType: .password,
            keyboardType: .default,
            autocapitalizationType: .none,
            autocorrectionType: .no
        )
    }
    static var codeTextField = TextFieldStyle { theme in
        TextFieldStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 20) ?? .systemFont(ofSize: 20),
            textContentType: .oneTimeCode,
            keyboardType: .default,
            autocapitalizationType: .none,
            autocorrectionType: .no
        )
    }
    
    static var changeEmailTextField = TextFieldStyle { theme in
        TextFieldStyleProperties(
            font: FontFamilyLibrary.gotham_book.asFont(size: 16) ?? .systemFont(ofSize: 16),
            placeholderColor: theme.grey01,
            textContentType: .emailAddress,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no
        )
    }
}
