//
//  ToggleButton.swift
//  Ninja
//
//  Created by Martin Burch on 11/4/22.
//

import UIKit

@IBDesignable
class CircularToggleButton: BaseToggleButton {
    
    internal var circleDiameter: CGFloat = 64 {
        didSet {
            circle.layer.cornerRadius = circleDiameter * 0.5
        }
    }
        
    internal var circle: UIView = {
        let cl = UIView()
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        cl.layer.cornerRadius = 0.5 * 64
        cl.layer.shadowColor = ColorThemeManager.shared.theme.black01.cgColor
        cl.layer.shadowOpacity = 0.2
        cl.layer.shadowOffset = CGSize(width: 4, height: 4)
        cl.layer.shadowRadius = 6
        cl.layer.masksToBounds = false
        cl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return cl
    }()
    
    internal var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    convenience init(title: String, image: UIImage? = nil) {
        self.init()
        
        setDisplay(title: title, image: image)
    }
    
    func setDisplay(title: String, image: UIImage? = nil) {
        label.text = title
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func updateState() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            
            if !self.isEnabled {
                self.circle.backgroundColor = self.disableBackgroundColor
                self.imageView.tintColor = self.disableForegroundColor
                self.label.textColor = self.unsetTextColor
                self.label.font = self.unsetFont
            } else {
                self.circle.backgroundColor = self.isSet ? self.setBackgroundColor : self.unsetBackgroundColor
                self.imageView.tintColor = self.isSet ? self.setForegroundColor : self.unsetForegroundColor
                self.label.textColor = self.isSet ? self.setTextColor : self.unsetTextColor
                self.label.font = self.isSet ? self.setFont : self.unsetFont
            }
        }
    }
        
    override func setupConstraints() {
        addSubview(label)
        addSubview(circle)
        circle.addSubview(imageView)

        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            circle.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -8),
            circle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            // Setting the priority here prevents constraints breaking if the cells' widths are set to exactly fill the collectionView's width.
            circle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).usingPriority(.defaultHigh),
            circle.widthAnchor.constraint(equalToConstant: circleDiameter),
            circle.heightAnchor.constraint(equalToConstant: circleDiameter),

            label.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            imageView.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
    }
}
