//
//  BaseTableViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 11/10/22.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refreshStyling()
    }
    
    internal func setupViews() {
        
    }
    
    internal func setupConstraints() {
        
    }
    
    internal func refreshStyling() {
        self.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
    }
}
