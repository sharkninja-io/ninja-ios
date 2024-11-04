//
//  ExploreView.swift
//
//  Created by Martin Burch on 10/25/22.
//


import UIKit

class ExploreHomeView: BaseXIBView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
            
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    @IBOutlet weak var lineSeperator: UIView!
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Timed Cooking Charts"
        subtitleLabel.text = "Our Ninja culinary team has developed cooking charts that will guide you toward a successful cook."
        headerTitle.text = "Popular Filter Groupings"
        
        filtersCollectionView.register(ExploreFilterCollectionViewCell.self, forCellWithReuseIdentifier: ExploreFilterCollectionViewCell.VIEW_ID)
        filtersCollectionView.register(ExploreLineSeperatorCollectionViewCell.self, forCellWithReuseIdentifier: ExploreLineSeperatorCollectionViewCell.VIEW_ID)
        recipesCollectionView.register(ExploreHomeGridCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHomeGridCollectionViewCell.VIEW_ID)
        
        let filtersLayout = UICollectionViewFlowLayout()
        filtersLayout.scrollDirection = .horizontal
        filtersLayout.minimumLineSpacing = 8
        filtersLayout.minimumInteritemSpacing = 8
        filtersCollectionView.setCollectionViewLayout(filtersLayout, animated: true)
        filtersCollectionView.showsHorizontalScrollIndicator = false
        
        let recipesLayout = UICollectionViewFlowLayout()
        recipesLayout.scrollDirection = .vertical
        recipesLayout.minimumLineSpacing = 8
        recipesLayout.minimumInteritemSpacing = 8
        recipesCollectionView.setCollectionViewLayout(recipesLayout, animated: true)
        recipesCollectionView.showsVerticalScrollIndicator = false 

    }
    
    override func refreshStyling() {
        super.refreshStyling()
        titleLabel.setStyle(.pairingTitleLabel)
        subtitleLabel.setStyle(.cookingChartSubtitleLabel)
        headerTitle.setStyle(.exploreHeaderTitle)
        lineSeperator.backgroundColor = theme().grey03
        backgroundColor = theme().primaryBackgroundColor
    }
}
