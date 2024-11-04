//
//  PairingPreparationItem.swift
//  Ninja
//
//  Created by Martin Burch on 11/30/22.
//

import UIKit

class BTPairingPreparationCell: BaseTableViewCell {
    
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
    
    @UsesAutoLayout var moreButton = UIButton()
    
    @UsesAutoLayout var iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var isImportant: Bool = false {
        didSet {
            zeroHeightConstraint?.isActive = !isImportant
        }
    }
    
    private var zeroHeightConstraint: NSLayoutConstraint?
    
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
        moreButton.setStyle(.accentedLinkButton)
        moreButton.contentHorizontalAlignment = .left
     }
    
    override func setupConstraints() {
        addSubview(importantLabel)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(moreButton)
        addSubview(iconView)
        
        zeroHeightConstraint = importantLabel.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            importantLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            importantLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            importantLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            importantLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: importantLabel.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: moreButton.topAnchor, constant: -8),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            infoLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
            
            moreButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            moreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            moreButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            moreButton.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
            
            iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            iconView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            iconView.widthAnchor.constraint(equalToConstant: 100),
            iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
}
