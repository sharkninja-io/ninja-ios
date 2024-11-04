//
//  CountryRegionView.swift
//  Ninja
//
//  Created by Martin Burch on 9/19/22.
//

import UIKit

class CountryRegionView: BaseXIBView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(CountryRegionViewCell.self, forCellReuseIdentifier: CountryRegionViewCell.VIEW_ID)
        titleLabel.text = "Please select your country/region."
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.isEnabled = false
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.authTitleLabel)
        titleLabel.lineBreakStrategy = .hangulWordPriority // This actually allows the line to break on the `/` character, so we're using it for now.
        continueButton.setStyle(.primaryButton)
    }
}
