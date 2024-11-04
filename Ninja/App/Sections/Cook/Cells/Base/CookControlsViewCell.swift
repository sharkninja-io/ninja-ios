//
//  CookModeViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit
import Combine

class CookControlsViewCell: BaseTableViewCell {
    
    internal var disposables = Set<AnyCancellable>()

    weak var tableView: UITableView?
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    var topConstraint: NSLayoutConstraint = .init()
    var bottomConstraint: NSLayoutConstraint = .init()
    var leadingConstraint: NSLayoutConstraint = .init()
    var trailingConstraint: NSLayoutConstraint = .init()
    
    var shadowContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 6
        view.layer.shadowColor = ColorThemeManager.shared.theme.black01.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    func connectData(data: CookItem) {
        disposables.removeAll()
    }

    func hideShadow() {
        shadowContainer.layer.shadowOpacity = 0
        topConstraint.constant = 0
        bottomConstraint.constant = 0
        leadingConstraint.constant = 0
        trailingConstraint.constant = 0
        layoutIfNeeded()
    }
    
    deinit {
        disposables.removeAll()
    }

    override func setupViews() {
        super.setupViews()
        
        self.selectionStyle = .none
        self.accessoryType = .none
    }
    
    override func refreshStyling() {
        self.backgroundColor = .clear
        shadowContainer.backgroundColor = theme().cellCookBackground
    }
    
    override func setupConstraints() {
        contentView.addSubview(shadowContainer)
        
        topConstraint = shadowContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8)
        bottomConstraint = shadowContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        leadingConstraint = shadowContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8)
        trailingConstraint = shadowContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
    }
}
