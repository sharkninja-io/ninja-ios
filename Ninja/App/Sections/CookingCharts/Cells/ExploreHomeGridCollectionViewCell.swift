//
//  FoodItemViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/30/23.
//


import UIKit

class ExploreHomeGridCollectionViewCell: BaseCollectionViewCell {
    
    override var isSelected: Bool {
         didSet {
             self.layer.borderColor = isSelected ? ColorThemeManager.shared.theme.primaryAccentColor.cgColor : ColorThemeManager.shared.theme.white01.cgColor
             self.layer.borderWidth =  isSelected ? 1.0 : 0
         }
     }
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var headerCaption: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func refreshStyling() {
        super.refreshStyling()
        headerCaption.setStyle(.cookingChartCellHeaderLabel)
        titleLabel.setStyle(.exploreHomeGridTitle)
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
         layer.shadowPath = UIBezierPath(
             roundedRect: bounds,
             cornerRadius: 16
         ).cgPath
        
        contentView.layoutIfNeeded()
        titleLabel.sizeToFit()
     }
    
    override func setupViews() {
       contentView.layer.cornerRadius = 16
       contentView.layer.masksToBounds = true
       
       layer.cornerRadius = 16
       layer.masksToBounds = false
       
       layer.shadowRadius = 4.0
       layer.shadowOpacity = 0.10
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func setupConstraints() {
        addSubview(imageView)
        addSubview(headerCaption)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 96),
            
            headerCaption.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            headerCaption.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            headerCaption.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerCaption.heightAnchor.constraint(equalToConstant: 15),
            
            titleLabel.topAnchor.constraint(equalTo: headerCaption.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }
}
