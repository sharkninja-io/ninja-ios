//
//  ExploreWoodFireTechnologyTableViewCell.swift
//  Ninja
//
//  Created by Rahul Sharma on 3/15/23.
//

import UIKit

class ExploreWoodFireToggleTableViewCell: BaseTableViewCell {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    
    internal var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.text = "Try Woodfire flavor".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var subtitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.text = "Add Rich, fully developed smokiness to any dish you make flavored by pellets."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    internal var titlesVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8.0
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    internal var toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "Woodfire technology".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var toggle: UISwitch = {
        let tg = UISwitch()
        tg.translatesAutoresizingMaskIntoConstraints = false
        tg.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tg.widthAnchor.constraint(equalToConstant: 44).isActive = true
        tg.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return tg
    }()
    
    internal var toggleHStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8.0
        sv.distribution = .fill
        sv.alignment = .center
        sv.setContentHuggingPriority(.required, for: .horizontal)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    override func refreshStyling() {
        super.refreshStyling()
        toggleLabel.setStyle(.settingsTitle)
        titleLabel.setStyle(.pageIndicatorTitleLabel, theme: theme())
        subtitleLabel.setStyle(.pageIndicatorLabel, theme: theme())
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        titlesVStack.addArrangedSubview(titleLabel)
        titlesVStack.addArrangedSubview(subtitleLabel)
        toggleHStack.addArrangedSubview(toggleLabel)
        toggleHStack.addArrangedSubview(toggle)
        
        self.contentView.addSubview(titlesVStack)
        self.contentView.addSubview(toggleHStack)
    
        NSLayoutConstraint.activate([
            titlesVStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            titlesVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            titlesVStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),

            toggleHStack.topAnchor.constraint(equalTo: self.titlesVStack.bottomAnchor, constant: 8),
            toggleHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            toggleHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            toggleHStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 12),
        ])
    }
    
    internal func setupConstraintForFilterSelection() {
        NSLayoutConstraint.activate([
            toggleHStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            toggleHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            toggleHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            toggleHStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 12),
        ])
    }
}
