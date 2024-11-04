//
//  BTPairingDeclinedBluetoothAccessViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 1/10/23.
//

import UIKit

class BTPairingDeclinedBluetoothAccessViewCell: BaseTableViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
        
    override func setupViews() {
        super.setupViews()
        
        selectedBackgroundView = UIView()
        self.separatorInset = .zero
        self.layoutMargins = .zero
        self.preservesSuperviewLayoutMargins = false

        selectedBackgroundView?.backgroundColor = ColorThemeManager.shared.theme.tertiaryAccentColor.withAlphaComponent(0.3)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        nameLabel.setStyle(.collectionViewCellLabel)
    }
    
    override func setupConstraints() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}

