//
//  PasswordTextFieldView.swift
//  Ninja
//
//  Created by Martin Burch on 9/12/22.
//

import UIKit
import SwiftUI

@IBDesignable
class PasswordWrapperView: TextFieldWrapperView {
    
    private var shownIcon: UIImage? { IconAssetLibrary.ico_eye_empty.asImage()?.tint(color: ColorThemeManager.shared.theme.primaryTextColor) }
    private var hiddenIcon: UIImage? { IconAssetLibrary.ico_eye_off.asImage()?.tint(color: ColorThemeManager.shared.theme.primaryTextColor) }
    
    private var _isPasswordHidden: Bool = false {
        didSet {
            flipShowHidePassword()
        }
    }
    var isPasswordHidden: Bool {
        get {
            return _isPasswordHidden
        }
    }
    
    var showHideButton: UIButton = {
        let button = UIButton()
        button.setImage(IconAssetLibrary.ico_eye_off.asSystemImage()?.tint(color: ColorThemeManager.shared.theme.secondaryTextColor), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // TODO: //
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flipShowHidePassword()
    }
    
    private func flipShowHidePassword() {
        textField.isSecureTextEntry = isPasswordHidden
        showHideButton.setImage(isPasswordHidden ? hiddenIcon : shownIcon, for: .normal)
    }
    
    func showPassword(shouldShow: Bool) {
        _isPasswordHidden = !shouldShow
    }
    
    override internal func setupView() {
        super.setupView()
        
        textField.clearButtonMode = .never
        textField.isSecureTextEntry = true
        textField.rightView = showHideButton
        textField.rightViewMode = .always
    }
    
    override internal func setupEvents() {
        super.setupEvents()
        showHideButton.onEvent { [weak self] control in
            guard let self = self else { return }
            self._isPasswordHidden = !self._isPasswordHidden
        }
    }
    
}
