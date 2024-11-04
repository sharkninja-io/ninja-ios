//
//  BaseXIBView.swift
//  Ninja
//
//  Created by Martin Burch on 11/1/22.
//

import UIKit

class BaseXIBView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        refreshStyling()
    }
    
    internal func setupViews() {
        initXIB(with: Self.VIEW_ID, owner: self)
    }
    
    internal func refreshStyling() {
        self.subviews.forEach { view in
            view.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        }
    }
}
