//
//  CookingChartsGalleryView.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/30/23.
//

import UIKit

class CookingChartGalleryView: BaseXIBView {
    
    @IBOutlet weak var pageIndicator: PageIndicator!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
        
    @IBOutlet weak var foodCategorySelectionTableView: UITableView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    override func setupViews() {
        super.setupViews()
        pageIndicator.pageTitleLabel.text = "Cooking Charts".uppercased()
        
        titleLabel.text = "What are you thinking to <Cookmode> today? "
        subtitleLabel.text = "Choose the type of food available in cook mode selected."
        
        foodCategorySelectionTableView.clipsToBounds = true
        foodCategorySelectionTableView.separatorStyle = .none
        foodCategorySelectionTableView.alwaysBounceVertical = false
        foodCategorySelectionTableView.bounces = false
        foodCategorySelectionTableView.showsVerticalScrollIndicator = false
        foodCategorySelectionTableView.register(FoodModeSelectionViewCell.self, forCellReuseIdentifier: FoodModeSelectionViewCell.VIEW_ID)
        
        foodCollectionView.register(ExploreHomeGridCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHomeGridCollectionViewCell.VIEW_ID)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        foodCollectionView.setCollectionViewLayout(layout, animated: true)

    }
    
    override func refreshStyling() {
        super.refreshStyling()
        titleLabel.setStyle(.pairingTitleLabel)
        subtitleLabel.setStyle(.cookingChartSubtitleLabel)
        backgroundColor = theme().primaryBackgroundColor
    }
}
    
