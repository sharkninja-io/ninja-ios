//
//  ErrorLogCell.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/19/22.
//

import UIKit
import GrillCore

class ErrorLogCell: BaseTableViewCell {
    
    @UsesAutoLayout var alertTitleLabel = UILabel()
    @UsesAutoLayout var dateLabel = UILabel()
    
    override internal func setupViews() {
        contentView.addSubview(alertTitleLabel)
        contentView.addSubview(dateLabel)
        
        alertTitleLabel.numberOfLines = 0
    }
    
    override internal func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),

            alertTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: DefaultSizes.topPadding),
            alertTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            alertTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            alertTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    override internal func refreshStyling() {
        alertTitleLabel.setStyle(.settingsCellTitle)
        dateLabel.setStyle(.textFieldTitleLabel) // TODO: Reuse unrelated style or create a new one with duplicate properties?
    }
    
    public func applyAttributes(_ grillError: GrillCoreSDK.GrillError) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: grillError.date)
        alertTitleLabel.text = "Error Code \(grillError.code). User-facing messages for codes are under development."
    }

}
