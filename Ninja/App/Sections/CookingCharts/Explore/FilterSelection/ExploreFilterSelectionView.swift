//
//  ExploreFilterSelectionView.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/15/23.
//


import UIKit

class ExploreFilterSelectionView: BaseXIBView {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    @IBOutlet weak var bannerSubtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
   
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    override func setupViews() {
        super.setupViews()
        applyButton.setTitle("Apply".uppercased(), for: .normal)
        bannerTitleLabel.text = "Try Woodfire flavor"
        bannerSubtitleLabel.text = "Add Rich, fully developed smokiness to any dish you make flavored by pellets."
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(ExploreFoodSelectorFilterTableViewCell.self, forCellReuseIdentifier: ExploreFoodSelectorFilterTableViewCell.VIEW_ID)
        tableView.register(ExploreCookModeFilterTableViewCell.self, forCellReuseIdentifier: ExploreCookModeFilterTableViewCell.VIEW_ID)
        tableView.register(ExploreCookTimeFilterTableViewCell.self, forCellReuseIdentifier: ExploreCookTimeFilterTableViewCell.VIEW_ID)

        tableView.separatorStyle = .singleLine        
        closeButton.setTitle("", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        applyButton.setStyle(.primaryButton, theme: theme())
        bannerTitleLabel.setStyle(.exploreWoodFireBannerTitle)
        bannerSubtitleLabel.setStyle(.exploreWoodFireBannerSubtitle)
        bannerView.backgroundColor = UIColor(patternImage: ImageAssetLibrary.img_woodfire_gradient.asImage() ?? UIImage())
        closeButton.tintColor = theme().primaryBackgroundColor
        backgroundColor = theme().primaryBackgroundColor
    }
}
