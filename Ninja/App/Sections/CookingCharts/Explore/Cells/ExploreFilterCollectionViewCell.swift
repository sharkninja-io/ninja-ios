//
//  ExploreFilterCollectionViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/16/23.
//

import UIKit

class ExploreFilterCollectionViewCell: BaseCollectionViewCell {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    var isFilteredApplied: Bool = false {
        didSet {
            refreshStyling()
        }
    }
    
    var isAllFilters: Bool = false {
        didSet {
            refreshStyling()
        }
    }
    
    var isClearFilter: Bool = false {
        didSet {
            refreshStyling()
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    override func refreshStyling() {
        super.refreshStyling()
        self.backgroundColor = theme().grey03
        imageView.image = IconAssetLibrary.ico_filter.asImage()?.tint(color: theme().primaryTextColor)
        titleLabel.setStyle(.exploreFilterCollectionViewTitle, theme: theme())
        titleLabel.underlineText(false)
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        if isFilteredApplied {
            titleLabel.setStyle(.exploreFilterCollectionViewTitleWithAlternateColor, theme: theme())
            self.backgroundColor = theme().primaryAccentColor
            titleLabel.underlineText(false)
        }
        
        if isAllFilters {
            self.backgroundColor = theme().black01
            titleLabel.setStyle(.exploreFilterCollectionViewTitleWithAlternateColor, theme: theme())
            imageView.image = IconAssetLibrary.ico_filter.asImage()?.tint(color: theme().white01)
            titleLabel.underlineText(false)

        }
        
        if isClearFilter {
            self.layer.cornerRadius = 0
            self.backgroundColor = theme().primaryBackgroundColor
            titleLabel.setStyle(.exploreFilterCollectionViewCellClearAllFilters)
            titleLabel.underlineText()
        }
    }
    
    override func setupConstraints() {
        hStack.addArrangedSubview(imageView)
        hStack.addArrangedSubview(titleLabel)


        contentView.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
