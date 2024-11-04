//
//  ExploreFiltersAppliedView.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/17/23.
//

import Foundation

import UIKit

class ExploreFiltersAppliedView: BaseXIBView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var lineSeperator: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Cooking Charts "
        subtitleLabel.text = "Ninja culinary team has developed cooking charts to guide you how to set your cook session successfully."
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        filtersCollectionView.setCollectionViewLayout(layout, animated: true)
        filtersCollectionView.showsHorizontalScrollIndicator = false
        
        filtersCollectionView.register(ExploreFilterCollectionViewCell.self, forCellWithReuseIdentifier: ExploreFilterCollectionViewCell.VIEW_ID)
        filtersCollectionView.register(ExploreLineSeperatorCollectionViewCell.self, forCellWithReuseIdentifier: ExploreLineSeperatorCollectionViewCell.VIEW_ID)
        
        recipesTableView.clipsToBounds = true
        recipesTableView.alwaysBounceVertical = false
        recipesTableView.bounces = false
        recipesTableView.showsVerticalScrollIndicator = false
        recipesTableView.register(ExploreRecipeListViewTableViewCell.self, forCellReuseIdentifier: ExploreRecipeListViewTableViewCell.VIEW_ID)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        titleLabel.setStyle(.pairingTitleLabel)
        subtitleLabel.setStyle(.cookingChartSubtitleLabel)
        resultsLabel.setStyle(.cookingChartItemDetailLabel)
        lineSeperator.backgroundColor = theme().grey03
        backgroundColor = theme().primaryBackgroundColor
    }
}
