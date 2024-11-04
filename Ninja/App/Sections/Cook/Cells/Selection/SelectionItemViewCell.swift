//
//  ModeItemViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/29/22.
//

import UIKit

class SelectionItemViewCell: BaseCollectionViewCell {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    var button: CircularToggleButton = {
        let button = CircularToggleButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setData(title: String, icon: UIImage?, identifier: AnyHashable?) {
        button.label.text = title
        button.imageView.image = icon?.withRenderingMode(.alwaysTemplate)
        button.identifier = identifier
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        self.backgroundColor = .clear
        
        button.setStyle(.circularTabButton, theme: theme())
    }
    
    override func setupConstraints() {
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
}
