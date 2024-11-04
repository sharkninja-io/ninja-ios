//
//  ToastView.swift
//  Ninja
//
//  Created by Martin Burch on 4/7/23.
//

import UIKit

@IBDesignable
class ToastView: BaseView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.monitorControlTheme }
    
    var closeCompletion: (() -> Void)?
    
    func setup(icon: UIImage?, title: String, message: String, colors: [CGColor]) {
        self.backgroundGradient.colors = colors
        self.messageIcon.image = icon
        self.title.text = title
        self.message.text = message
    }
    
    var backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.type = .axial
        return gradient
    }()
    
    var messageIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_grill.asTemplateImage()
        image.contentMode = .scaleAspectFit
        return image
    }()

    var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        return label
    }()
    
    var message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message"
        label.numberOfLines = 0
        return label
    }()
    
    var messageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(IconAssetLibrary.ico_x_close.asTemplateImage()?.tint(color: .white), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.largeContentImageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        closeButton.onEvent { [weak self] control in
            self?.closeCompletion?()
        }
        
        self.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.addSubview(messageContainer)
        messageContainer.addSubview(messageIcon)
        messageContainer.addSubview(title)
        messageContainer.addSubview(message)
        self.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            messageIcon.topAnchor.constraint(equalTo: messageContainer.topAnchor),
            messageIcon.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor),
            messageIcon.widthAnchor.constraint(equalToConstant: 24),
            messageIcon.heightAnchor.constraint(equalToConstant: 24),
            
            title.topAnchor.constraint(equalTo: messageContainer.topAnchor),
            title.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -8),
            title.leadingAnchor.constraint(equalTo: messageIcon.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor),

            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            message.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor),
            message.leadingAnchor.constraint(equalTo: messageIcon.trailingAnchor, constant: 8),
            message.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor),
            
            messageContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            messageContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            messageContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            messageContainer.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            closeButton.leadingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func refreshStyling() {
        backgroundGradient.frame = self.bounds
        
        title.setStyle(.cookToastTitleLabel, theme: theme())
        message.setStyle(.cookToastMessageLabel, theme: theme())
        messageIcon.tintColor = theme().primaryTextColor
    }
}
