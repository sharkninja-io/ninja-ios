//
//  BTPermissionsTableViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 12/22/22.
//

import UIKit

class BTPermissionsTableViewCell: BaseTableViewCell {
    
    var isEnabled: Bool = false {
        didSet {
            refreshStyling()
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    var enabledIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_arrow_circle_small.asImage()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var importantLabel: UILabel = {
        let label = UILabel()
        label.text = " IMPORTANT"
        label.attachImage(IconAssetLibrary.ico_warning.asImage() ?? UIImage(),
                          size: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    
    internal var textVStack: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 4.0
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    internal var hStack: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 16.0
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var isImportant: Bool = false {
        didSet {
            importantLabel.isHidden = !isImportant
        }
    }
    

    override func setupViews() {
        super.setupViews()
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .clear
        self.separatorInset = .zero
        self.layoutMargins = .zero
        self.preservesSuperviewLayoutMargins = false 
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        nameLabel.setStyle(.collectionViewCellLabel)
        descriptionLabel.setStyle(.pairingInfoLabel)
        importantLabel.setStyle(.pairingWarningLabel)
        enabledIcon.image = isEnabled ? IconAssetLibrary.ico_checkmark_circle_small.asImage() : IconAssetLibrary.ico_arrow_circle_small.asImage()
    }
    
    override func setupConstraints() {
        textVStack.addArrangedSubview(importantLabel)
        textVStack.addArrangedSubview(nameLabel)
        textVStack.addArrangedSubview(descriptionLabel)
        hStack.addArrangedSubview(textVStack)
        hStack.addArrangedSubview(enabledIcon)
        contentView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
        ])
    }
}
