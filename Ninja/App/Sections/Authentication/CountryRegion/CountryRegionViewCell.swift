//
//  CountryRegionViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 9/19/22.
//

import UIKit

class CountryRegionViewCell: BaseTableViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        selectedBackgroundView = UIView()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        selectedBackgroundView?.backgroundColor = ColorThemeManager.shared.theme.tertiaryAccentColor.withAlphaComponent(0.3)
        nameLabel.setStyle(.collectionViewCellLabel)
    }
    
    override func setupConstraints() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
    }
}
