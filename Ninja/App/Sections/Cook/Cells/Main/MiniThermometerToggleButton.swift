//
//  MiniThermometerViewCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 2/21/23.
//

import UIKit
import Combine

class MiniThermometerToggleButton: BaseToggleButton {
    
    var foregroundColor: UIColor = .white
    var gradientColors: [CGColor] = [
        UIColor.red.cgColor,
        UIColor.yellow.cgColor
    ]
    var iconImage: UIImage?

    lazy var gradientBorderLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPointMake(1, 0)
        layer.endPoint = CGPointMake(0, 1)
        layer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        return layer
    }()
    
    func setupGradientBorder(colors: [CGColor], _ borderWidth: Double = 1, _ cornerRadius: Double = 16) {
        gradientBorderLayer.frame = CGRect(
            origin: .zero,
            size: CGSize(width: bounds.size.width + borderWidth, height: bounds.size.height + borderWidth))
        gradientBorderLayer.colors = colors

        let mask = CAShapeLayer()
        let maskRect = CGRect(
            x: bounds.origin.x + borderWidth/2,
            y: bounds.origin.y + borderWidth/2,
            width: bounds.size.width - borderWidth,
            height: bounds.size.height - borderWidth)
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.lineWidth = borderWidth
        mask.strokeColor = UIColor.white.cgColor // Can be any color. Just not clear
        mask.fillColor = nil
        gradientBorderLayer.mask = mask
    }
    
    func addGradientBorder() {
        layer.addSublayer(gradientBorderLayer)
    }
    
    func removeGradientBorder() {
         gradientBorderLayer.removeFromSuperlayer()
    }
    
    var isAttached: Bool = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    func updateIcon() {
        icon.image = isAttached ?
            IconAssetLibrary.ico_thermometer.asImage()?.tint(color: foregroundColor) :
            IconAssetLibrary.ico_thermometer_unplugged.asImage()?.tint(color: foregroundColor)
    }
    
    func setBorderColors(colors: [CGColor]) {
        gradientColors = colors
        setupGradientBorder(colors: gradientColors)
        updateState()
    }
    
    @UsesAutoLayout var icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return image
    }()
    
    @UsesAutoLayout var foodTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        return label
    }()
    // Can be a temperature, a timer, or "done".
    @UsesAutoLayout var thermometerStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        return label
    }()
    
    override func setup() {
        super.setup()

        layer.cornerRadius = 16
        setupGradientBorder(colors: gradientColors)
    }
    
    func setStyle(backgroundColor: UIColor, foregroundColor: UIColor, font: UIFont) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        updateIcon()
        foodTypeLabel.textColor = foregroundColor
        thermometerStatusLabel.textColor = foregroundColor
        foodTypeLabel.font = font
        thermometerStatusLabel.font = font
    }
        
    override func updateState() {
        if isSet {
            addGradientBorder()
        } else {
            removeGradientBorder()
        }
    }
        
    override func setupConstraints() {
        super.setupConstraints()
        
        self.addSubview(icon)
        self.addSubview(foodTypeLabel)
        self.addSubview(thermometerStatusLabel)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            icon.trailingAnchor.constraint(equalTo: foodTypeLabel.leadingAnchor),
            
            foodTypeLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor),
            foodTypeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            foodTypeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            foodTypeLabel.trailingAnchor.constraint(equalTo: thermometerStatusLabel.leadingAnchor, constant: -8),
            
            thermometerStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            thermometerStatusLabel.leadingAnchor.constraint(equalTo: foodTypeLabel.trailingAnchor, constant: 8),
            thermometerStatusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            thermometerStatusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
