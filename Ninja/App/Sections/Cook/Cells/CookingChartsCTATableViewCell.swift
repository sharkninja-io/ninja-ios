//
//  CookingChartsCTAView.swift
//  Ninja
//
//  Created by Richard Jacobson on 1/25/23.
//

import Foundation
import UIKit

// ...It means call to action. We can change it if you folks prefer
@IBDesignable
class CookingChartsCTATableViewCell: BaseTableViewCell {
    
    @UsesAutoLayout var icon = UIImageView()
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var detailLabel = UILabel()
    @UsesAutoLayout var goToChartsLabel = UILabel()
    @UsesAutoLayout var arrowIcon = UIImageView()
    
    override func setupViews() {
        super.setupViews()
        
        layer.cornerRadius = 12
        
        titleLabel.text = "Do you want help, Chef?"
        detailLabel.text = "Our culinary team has developed cooking charts to guide you how to set your cook session successfully."
        goToChartsLabel.text = "Go to cooking charts"
        
        icon.contentMode = .scaleAspectFit
        detailLabel.numberOfLines = 0
    }
    
    override func setupConstraints() {
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(goToChartsLabel)
        addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailLabel.heightAnchor.constraint(equalToConstant: 48),

            
            goToChartsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            goToChartsLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8),
            
            arrowIcon.leadingAnchor.constraint(equalTo: goToChartsLabel.trailingAnchor, constant: 8),
            arrowIcon.centerYAnchor.constraint(equalTo: goToChartsLabel.centerYAnchor),
            arrowIcon.heightAnchor.constraint(equalToConstant: 14),
            arrowIcon.widthAnchor.constraint(equalToConstant: 14),
            arrowIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    override func refreshStyling() {
        backgroundColor = ColorThemeManager.shared.theme.tertiaryAccentColor
        
        titleLabel.setStyle(.callToActionTitle)
        detailLabel.setStyle(.cookPickerDetailLabel)
        goToChartsLabel.setStyle(.cookCallToActionLabel)
        
        icon.image = IconAssetLibrary.ico_chef_hat.asImage()?.tint(color: ColorThemeManager.shared.theme.primaryForegroundColor) ?? UIImage()
        arrowIcon.image = IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: ColorThemeManager.shared.theme.primaryForegroundColor) ?? UIImage()
    }
}
