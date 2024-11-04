//
//  SimpleModalView.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/20/22.
//

import UIKit

class SimpleModalView: BaseView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    /// Dark view that spans the screen to put focus on the alert content
    @UsesAutoLayout internal var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    @UsesAutoLayout internal var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor // We want this to be invisible on light mode, but provide clarity on dark mode, so it will always be white
        return view
    }()
    internal lazy var contentViewCenterY: NSLayoutConstraint = contentView.centerYAnchor.constraint(equalTo: centerYAnchor)

    internal lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 32
        return stack
    }()
    
    @UsesAutoLayout var topIcon = UIImageView()
    @UsesAutoLayout var imageView = UIImageView()
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var descriptionLabel = UILabel()
    
    @UsesAutoLayout var horizontalImageStack = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        initialPresentation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        addSubview(bgView)
        addSubview(contentView)
        addSubview(mainStack)
        
        topIcon.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFill
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentViewCenterY,
            contentView.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: -32),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            contentView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 32),
            
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
    }
    
    override func refreshStyling() {
        contentView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        titleLabel.setStyle(.alertTitle, theme: theme())
        descriptionLabel.setStyle(.alertSubtitle, theme: theme())
    }
    
    /// Animate the from below the sceren to the middle
    internal func initialPresentation() {
        contentViewCenterY.constant = self.bounds.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.contentViewCenterY.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                self.bgView.backgroundColor = .black.withAlphaComponent(0.66)
                self.layoutIfNeeded()
            }
        }
    }
    
    public func applyAttributes(_ manager: SimpleModalManager) {
        if let icon = manager.topIcon {
            topIcon.image = icon
            mainStack.addArrangedSubview(topIcon)
            NSLayoutConstraint.activate([
                topIcon.heightAnchor.constraint(equalToConstant: 64)
            ])
        }
        
        if let title = manager.title {
            titleLabel.text = title
            mainStack.addArrangedSubview(titleLabel)
        }
        
        if let description = manager.description {
            descriptionLabel.text = description
            mainStack.addArrangedSubview(descriptionLabel)
            mainStack.setCustomSpacing(10, after: titleLabel)
        }
        
        if let image = manager.image {
            imageView.image = image
            mainStack.addArrangedSubview(imageView)
        } else if let images = manager.images {
            setupImageHstack(images)
        }
        
    }
    
    private func setupImageHstack(_ images: [UIImage?]) {
        horizontalImageStack.distribution = .fillEqually
        horizontalImageStack.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            horizontalImageStack.addArrangedSubview(imageView)
        }
        
        mainStack.insertArrangedSubview(horizontalImageStack, at: (mainStack.arrangedSubviews.firstIndex(of: titleLabel) ?? 0) + 1)
        mainStack.setCustomSpacing(16, after: horizontalImageStack)
    }
}
