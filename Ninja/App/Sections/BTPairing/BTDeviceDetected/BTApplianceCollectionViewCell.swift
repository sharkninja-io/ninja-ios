//
//  BTApplianceCollectionViewCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/28/22.
//

import UIKit
import CoreBluetooth
import GrillCore

class BTApplianceCollectionViewCell: BaseCollectionViewCell {
    
    var macAddress: String = "" {
        didSet {
            if macAddress.isNotEmpty() {
                subtitleLabel.text = macAddress
            }
        }
    }
    var uuid: String?
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    @UsesAutoLayout private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    @UsesAutoLayout private var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [UIView(), titleLabel, subtitleLabel, UIView()])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout private var subtitleLabel = UILabel()
    
    
    override func setupViews() {
        imageView.image = ImageAssetLibrary.img_ogxl_angled.asImage()
        titleLabel.text = "Ninja Woodfire™ ProConnect XL Outdoor Grill & Smoker"
        subtitleLabel.text = "Model # IG601"
    }
    
    override func setupConstraints() {
        addSubview(bgView)
        addSubview(vStack)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            imageView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16),
            imageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 152),
            
            vStack.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20).usingPriority(.defaultHigh),
            vStack.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -20).usingPriority(.defaultHigh),
            vStack.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 24),
            vStack.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            vStack.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -4)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.infoLabel)
        subtitleLabel.setStyle(.itemLabel)
        updateSelection()
    }
    
    func updateSelection() {
        bgView.layer.borderColor = isSelected ? ColorThemeManager.shared.theme.primaryAccentColor.cgColor : ColorThemeManager.shared.theme.primaryForegroundColor.cgColor
    }
    
}

