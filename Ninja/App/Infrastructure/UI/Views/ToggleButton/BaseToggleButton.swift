//
//  ToggleButton.swift
//  Ninja
//
//  Created by Martin Burch on 11/4/22.
//

import UIKit

@IBDesignable
class BaseToggleButton: UIControl {
    
    var setForegroundColor: UIColor? = ColorThemeManager.shared.theme.primaryTextColor {
        didSet {
            updateState()
        }
    }
    var unsetForegroundColor: UIColor? = ColorThemeManager.shared.theme.secondaryTextColor {
        didSet {
            updateState()
        }
    }
    var disableForegroundColor: UIColor? = ColorThemeManager.shared.theme.primaryDisabledForegroundColor {
        didSet {
            updateState()
        }
    }
    
    var setTextColor: UIColor? = ColorThemeManager.shared.theme.primaryBackgroundColor {
        didSet {
            updateState()
        }
    }
    var unsetTextColor: UIColor? = ColorThemeManager.shared.theme.secondaryBackgroundColor {
        didSet {
            updateState()
        }
    }
    var disableTextColor: UIColor? = ColorThemeManager.shared.theme.primaryDisabledForegroundColor {
        didSet {
            updateState()
        }
    }
    
    var setBackgroundColor: UIColor? = ColorThemeManager.shared.theme.primaryBackgroundColor {
        didSet {
            updateState()
        }
    }
    var unsetBackgroundColor: UIColor? = ColorThemeManager.shared.theme.secondaryBackgroundColor {
        didSet {
            updateState()
        }
    }
    var disableBackgroundColor: UIColor? = ColorThemeManager.shared.theme.primaryDisabledBackgroundColor {
        didSet {
            updateState()
        }
    }
    
    var setFont: UIFont? = FontFamilyLibrary.gotham_bold.asFont(size: 12) {
        didSet {
            updateState()
        }
    }
    var unsetFont: UIFont? = FontFamilyLibrary.gotham_book.asFont(size: 12) {
        didSet {
            updateState()
        }
    }
    
    var isSet: Bool = false {
        didSet {
            updateState()
        }
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "title"
        return label
    }()

    var identifier: Any? = nil

    convenience init(title: String, identifier: Any? = nil) {
        self.init()
        label.text = title
        self.identifier = identifier
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupConstraints()
        setupTouch()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
        setupConstraints()
        setupTouch()
    }
    
    internal func setup() {        
        updateState()

//        self.onEvent { [weak self] toggle in
//            guard let self = self else { return }
//            self.isSet = !self.isSet
//        }
    }
    
    private func setupTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        if isEnabled {
            guard sender.view != nil else { return }
            
            isSet = true
            sendActions(for: .primaryActionTriggered)
            sendActions(for: .touchUpInside)
        }
    }
    
    func setStyle(_ style: ButtonStyle, theme: ColorTheme = ColorThemeManager.shared.theme) {
        let props = style.properties(theme)
        setTextColor = props.textHighlightColor
        unsetTextColor = props.textColor
        disableTextColor = props.textDisabledColor
        setForegroundColor = props.tintColor
        unsetForegroundColor = props.textColor
        disableForegroundColor = props.textDisabledColor
        setBackgroundColor = props.highlightBackgroundColor
        unsetBackgroundColor = props.backgroundColor
        disableBackgroundColor = props.disabledBackgroundColor
        setFont = props.font
        unsetFont = props.font
    }
    
    internal func updateState() { }
        
    internal func setupConstraints() { }
}
