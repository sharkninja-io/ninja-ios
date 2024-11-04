//
//  PairingPreparationBottomImageCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/7/23.
//

import UIKit

class PairingPreparationBottomImageCell: BaseTableViewCell {
    
    @UsesAutoLayout var importantLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = " IMPORTANT"
        label.attachImage(IconAssetLibrary.ico_warning.asImage() ?? UIImage(),
                          size: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
        return label
    }()
    
    @UsesAutoLayout var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    @UsesAutoLayout var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
        
    @UsesAutoLayout var iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
        
    override func setupViews() {
        super.setupViews()
        self.selectionStyle = .none
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        importantLabel.setStyle(.pairingWarningLabel)
        titleLabel.setStyle(.pairingPageTitleLabel)
        titleLabel.numberOfLines = 0
        infoLabel.setStyle(.pairingInfoLabel)
     }
    
    override func setupConstraints() {
        addSubview(importantLabel)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(iconView)
        
        NSLayoutConstraint.activate([
            importantLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            importantLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            importantLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: importantLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: iconView.topAnchor, constant: -10),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                        
            iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            // Try to get the image to be its preferred height from the figma, but don't let it be wider than the cell.
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 150).usingPriority(.defaultLow),
            iconView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor).usingPriority(.required)
        ])
    }
}

