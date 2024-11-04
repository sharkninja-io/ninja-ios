//
//  ExploreFilterBottomSheetModalView.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/16/23.
//

import UIKit

class ExploreFilterBottomSheetModalView: BaseXIBView {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var tapToDismissView: UIView!
    @IBOutlet weak var lineSeperator: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var modalHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var bottomLabel: UILabel!
   
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        
        tableView.register(ExploreFoodSelectorFilterTableViewCell.self, forCellReuseIdentifier: ExploreFoodSelectorFilterTableViewCell.VIEW_ID)
        tableView.register(ExploreCookModeFilterTableViewCell.self, forCellReuseIdentifier: ExploreCookModeFilterTableViewCell.VIEW_ID)
        tableView.register(ExploreCookTimeFilterTableViewCell.self, forCellReuseIdentifier: ExploreCookTimeFilterTableViewCell.VIEW_ID)
        
        applyButton.setTitle("Apply".uppercased(), for: .normal)
        bottomLabel.text = " When filtering by this option, the following cook mode will not be available: Broil"
        bottomLabel.attachImage(IconAssetLibrary.ico_warning.asImage() ?? UIImage(),
                                size: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    }
    
    override func refreshStyling() {
        applyButton.setStyle(.primaryButton, theme: theme())
        bottomLabel.setStyle(.pageIndicatorLabel, theme: theme())
        
        lineSeperator.backgroundColor = theme().grey03
        tapToDismissView.backgroundColor = .clear
        modalView.backgroundColor = theme().primaryBackgroundColor
        
        modalView.layer.cornerRadius = 25.0
        modalView.layer.shadowColor = theme().grey01.cgColor
        modalView.layer.shadowOffset = .zero
        modalView.layer.shadowOpacity = 0.2
        modalView.layer.shadowRadius = 4
    }
}
