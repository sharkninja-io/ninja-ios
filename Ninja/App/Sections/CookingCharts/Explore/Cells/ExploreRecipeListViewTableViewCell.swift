//
//  RecipeListViewTableViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/13/23.
//

import UIKit

class ExploreRecipeListViewTableViewCell: BaseTableViewCell {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }

    var showPorkBadge: Bool = false {
        didSet {
            updateBadge()
        }
    }
    
    var showBeefBadge: Bool = false {
        didSet {
            updateBadge()
        }
    }

    var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
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
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cookTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Cook Time".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cookTypeTempLabel: UILabel = {
        let label = UILabel()
        label.text = "Grill Temp".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var lineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorThemeManager.shared.theme.grey03
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var recipeCookTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var recipeCookTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var foodCateogryBadge: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        button.layer.borderWidth = 1
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return button
   }()
    
    internal var recipeTimeVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var recipeTempVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var recipeDetailsHStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12.0
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var infoVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var recipeBadgeHStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4.0
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.isHidden = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func refreshStyling() {
        super.refreshStyling()
        headerCaption.setStyle(.cookingChartCellHeaderLabel)
        titleLabel.setStyle(.callToActionTitle)
    
        cookTimeLabel.setStyle(.cookingChartsRecipeListTimeLabel)
        cookTypeTempLabel.setStyle(.cookingChartsRecipeListTimeLabel)
        
        recipeCookTempLabel.setStyle(.cookCellSimpleTitle)
        recipeCookTimeLabel.setStyle(.cookCellSimpleTitle)
        
        foodCateogryBadge.layer.cornerRadius = 10
        foodCateogryBadge.layer.borderColor = UIColor.clear.cgColor
        foodCateogryBadge.backgroundColor = theme().tertiaryAccentColor
    }
    
    func updateBadge() {
        if showPorkBadge {
            foodCateogryBadge.setImage(IconAssetLibrary.ico_pig.asImage(), for: .normal)
            recipeBadgeHStack.isHidden = false
        } else if showBeefBadge {
            foodCateogryBadge.setImage(IconAssetLibrary.ico_cow.asImage(), for: .normal)
            recipeBadgeHStack.isHidden = false
        } else {
            recipeBadgeHStack.isHidden = true
        }
    }

    override func setupConstraints() {
        infoVStack.addArrangedSubview(headerCaption)
        infoVStack.addArrangedSubview(titleLabel)
        
        recipeTimeVStack.addArrangedSubview(recipeCookTimeLabel)
        recipeTimeVStack.addArrangedSubview(cookTimeLabel)
        
        recipeTempVStack.addArrangedSubview(recipeCookTempLabel)
        recipeTempVStack.addArrangedSubview(cookTypeTempLabel)
        
        recipeDetailsHStack.addArrangedSubview(recipeTimeVStack)
        recipeDetailsHStack.addArrangedSubview(lineSeperator)
        recipeDetailsHStack.addArrangedSubview(recipeTempVStack)
        
        recipeBadgeHStack.addArrangedSubview(foodCateogryBadge)
        
        addSubview(recipeImageView)
        addSubview(infoVStack)
        addSubview(recipeDetailsHStack)
        addSubview(recipeBadgeHStack)

        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recipeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -36),
            recipeImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -36),

            recipeDetailsHStack.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 12),
            recipeDetailsHStack.topAnchor.constraint(equalTo: infoVStack.bottomAnchor, constant: 8),
            recipeDetailsHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
        
            lineSeperator.widthAnchor.constraint(equalToConstant: 1),
            lineSeperator.heightAnchor.constraint(equalTo: recipeTimeVStack.heightAnchor, constant: -10),

            infoVStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            infoVStack.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 12),
            infoVStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            recipeBadgeHStack.topAnchor.constraint(equalTo: infoVStack.topAnchor),
            recipeBadgeHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
        ])
    }
}
