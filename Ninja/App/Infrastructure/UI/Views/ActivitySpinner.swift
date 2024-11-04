//
//  ActivitySpinner.swift
//  Ninja
//
//  Created by Martin Burch on 11/16/22.
//

import UIKit

@IBDesignable
class ActivitySpinner: BaseView { // TODO: UIImageView???
    
    var image: UIImage? = ImageAssetLibrary.img_spinner_ellipse.asImage() {
        didSet {
            spinner.image = image
        }
    }
    
    var color: UIColor = ColorThemeManager.shared.theme.primaryAccentColor {
        didSet {
            spinner.tintColor = color
        }
    }
    
    var spinner: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = ImageAssetLibrary.img_spinner_ellipse.asImage()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func setupViews() {
        super.setupViews()
        
        spinner.image = image
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        spinner.tintColor = color
    }
    
    override func layoutSubviews() {
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: self.topAnchor),
            spinner.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func start(duration: TimeInterval = 1) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = duration
        animation.repeatCount = .greatestFiniteMagnitude
        spinner.layer.add(animation, forKey: "transform.rotation")
    }
    
    func stop() {
        spinner.layer.removeAllAnimations()
    }
}
