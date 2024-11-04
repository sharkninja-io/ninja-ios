//
//  CookControlsHeader.swift
//  Ninja
//
//  Created by Martin Burch on 12/28/22.
//

import UIKit

class CookControlsHeader: BaseTableViewHeaderFooterView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func refreshStyling() {
        super.refreshStyling()
        
        titleLabel.setStyle(.cookGroupTitle, theme: theme())
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.contentView.backgroundColor = .clear
        let view = UIView()
        view.backgroundColor = .clear
        self.backgroundView = view
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8)
        ])
    }
}
