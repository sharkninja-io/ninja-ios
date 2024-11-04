//
//  ProfileFooterCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/15/22.
//

import UIKit
 
class ProfileFooterCell: BaseTableViewCell {
    
    @UsesAutoLayout var requiredFieldLabel = UILabel()
    @UsesAutoLayout var deleteAccountButton = UIButton()
    
    
    override func setupViews() {
        selectionStyle = .none
        
        contentView.addSubview(requiredFieldLabel)
        contentView.addSubview(deleteAccountButton)
        
        requiredFieldLabel.text = "(*) This field is required"
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlinedString = NSAttributedString(string: "Delete Account".uppercased(), attributes: underlineAttribute)
        deleteAccountButton.setAttributedTitle(underlinedString, for: .normal)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            requiredFieldLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            requiredFieldLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            requiredFieldLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            requiredFieldLabel.heightAnchor.constraint(equalToConstant: requiredFieldLabel.font.pointSize), // Not making this constraint leads to the cell getting compressed. Unclear why.
            
            deleteAccountButton.topAnchor.constraint(equalTo: requiredFieldLabel.bottomAnchor, constant: 32),
            deleteAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: DefaultSizes.bottomPadding)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        requiredFieldLabel.setStyle(.settingsCellDetail)
        deleteAccountButton.setStyle(.destructiveLinkButton)
    }
}
