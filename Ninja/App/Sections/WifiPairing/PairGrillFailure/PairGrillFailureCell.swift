//
//  PairGrillFailureCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/5/22.
//

import UIKit

class PairGrillFailureCell: BaseTableViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var iconView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
        
    override func setupViews() {
        super.setupViews()
        
        self.selectionStyle = .none
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.collectionViewCellLabel)
        infoLabel.setStyle(.infoLabel)
     }
    
    override func setupConstraints() {
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(iconView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            infoLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
            
            iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            iconView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            iconView.widthAnchor.constraint(equalToConstant: 96),
        ])
    }
}
