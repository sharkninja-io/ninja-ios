//
//  BTEducationalCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/3/23.
//

import UIKit

class BTEducationalCell: BaseTableViewCell {
    
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var infoLabel = UILabel()
    @UsesAutoLayout var iconView = UIImageView()
    
    lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
        
    override func setupViews() {
        super.setupViews()
        
        selectionStyle = .none
        
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        infoLabel.numberOfLines = 0
        iconView.contentMode = .scaleAspectFit
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingPageTitleLabel) // TODO: Text styling doesn't exactly match figma
        infoLabel.setStyle(.pairingInfoLabel)
    }
    
    override func setupConstraints() {
        contentView.addSubview(textStack)
        contentView.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textStack.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: DefaultSizes.trailingPadding),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Width is set in `.populate()`
            iconView.heightAnchor.constraint(equalToConstant: 80),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // Setting priority for these stops Autolayout from misbehaving when trying to determine the size of the cells
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).usingPriority(.fittingSizeLevel),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32).usingPriority(.fittingSizeLevel)
            
        ])
    }
    
    func populate(with item: BTEducationalItem) {
        iconView.image = item.image
        iconView.widthAnchor.constraint(equalToConstant: item.image != nil ? 80 : 0).isActive = true
        
        titleLabel.text = item.title
        infoLabel.text = item.info
    }
}
