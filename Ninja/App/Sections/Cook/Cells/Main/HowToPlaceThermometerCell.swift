//
//  HowToPlaceThermometerCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 2/7/23.
//

import UIKit

class HowToPlaceThermometerCell: CookControlsViewCell {
    
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout private var infolabel = UILabel()
    @UsesAutoLayout private var thermometerImageView = UIImageView()
    
    override func setupViews() {
        super.setupViews()
        selectionStyle = .none
        layer.cornerRadius = 10
        titleLabel.text = "How to place your thermometer?"
        infolabel.text = "Insert the Built-In Thermometer into the thickest part of your protein while the grill is preheating."
        thermometerImageView.image = ImageAssetLibrary.img_insert_thermometer.asImage() ?? UIImage()
        
    }
    
    override func setupConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(infolabel)
        contentView.addSubview(thermometerImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            infolabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            infolabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infolabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).usingPriority(.defaultHigh),
            infolabel.trailingAnchor.constraint(equalTo: thermometerImageView.leadingAnchor, constant: -10),
            
            thermometerImageView.heightAnchor.constraint(equalToConstant: 52),
            thermometerImageView.widthAnchor.constraint(equalToConstant: 47),
            thermometerImageView.topAnchor.constraint(equalTo: infolabel.topAnchor, constant: 16),
            thermometerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            thermometerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).usingPriority(.defaultHigh)
            
        ])
    }
    
    override func refreshStyling() {
        backgroundColor = theme().tertiaryAccentColor
        titleLabel.setStyle(.thermometerCtaTitleLabel, theme: theme())
        infolabel.setStyle(.thermometerCtaInfoLabel, theme: theme())
    }
}
