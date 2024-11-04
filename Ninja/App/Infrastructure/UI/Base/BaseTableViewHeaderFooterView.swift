//
//  BaseTableViewHeaderFooterView.swift
//  Ninja
//
//  Created by Martin Burch on 12/28/22.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

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
    }
    
}
