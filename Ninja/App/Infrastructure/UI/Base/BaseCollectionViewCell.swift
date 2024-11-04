//
//  BaseCollectionViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 1/10/23.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
