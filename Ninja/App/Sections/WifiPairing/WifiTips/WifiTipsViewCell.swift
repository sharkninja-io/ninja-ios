//
//  WifiTipsViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/2/22.
//

import UIKit

class WifiTipsViewCell: BaseTableViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.pairingWifiItemLabel)
        infoLabel.setStyle(.pairingWifiInfoLabel)
    }

    override func setupConstraints() {
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
}
