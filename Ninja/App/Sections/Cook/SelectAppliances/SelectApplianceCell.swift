//
//  SelectApplianceCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/17/23.
//

import UIKit

class SelectApplianceCell: BaseTableViewCell {
    
    var hidesTopSeparator = false
    var hidesBottomSeparator = false
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let topSeparator = subviews.first { $0.frame.minY == 0 && $0.frame.height <= 1 }
        let bottomSeparator = subviews.first { $0.frame.minY >= bounds.maxY - 1 && $0.frame.height <= 1 }
        topSeparator?.isHidden = hidesTopSeparator
        bottomSeparator?.isHidden = hidesBottomSeparator
    }
    
    override func setupViews() {
        super.setupViews()
        selectedBackgroundView = UIView()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        selectedBackgroundView?.backgroundColor = ColorThemeManager.shared.theme.tertiaryAccentColor.withAlphaComponent(0.3)
        nameLabel.setStyle(.selectApplianceTableViewCellLabel)
    }
    
    override func setupConstraints() {
        self.contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
        ])
    }
}
