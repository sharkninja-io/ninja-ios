//
//  ExploreLineSeperatorCollectionViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 4/3/23.
//

import UIKit

class ExploreLineSeperatorCollectionViewCell: BaseCollectionViewCell {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
 
    internal var lineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorThemeManager.shared.theme.grey03
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func refreshStyling() {
        super.refreshStyling()
        self.lineSeperator.backgroundColor = theme().grey03
    }
    
    override func setupConstraints() {
        addSubview(lineSeperator)

        NSLayoutConstraint.activate([
            lineSeperator.heightAnchor.constraint(equalToConstant: 20),
            lineSeperator.widthAnchor.constraint(equalToConstant: 2),
        ])
    }
}
