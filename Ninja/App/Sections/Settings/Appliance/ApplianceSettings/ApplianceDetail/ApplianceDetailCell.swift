//
//  ApplianceDetailCell.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/19/22.
//

import UIKit

class ApplianceDetailCell: BaseTableViewCell {
    
    @UsesAutoLayout var leftLabel = UILabel()
    @UsesAutoLayout var rightLabel = UILabel()
    
    override func setupViews() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        selectionStyle = .none
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 8)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        leftLabel.setStyle(.applianceDetailLeadingLabel)
        rightLabel.setStyle(.applianceDetailTrailingLabel)
    }
    
    public func connectData(_ row: Int) {
        guard row < ApplianceDetailViewController.DetailCellField.allCases.count else { return }
        let item = ApplianceDetailViewController.DetailCellField.allCases[row]
        leftLabel.text = item.rawValue
        rightLabel.text = item.getProperty()
    }
}
