//
//  CookModeViewCell.swift
//  Ninja
//
//  Created by Richard Jacobson on 2/21/23.
//

import UIKit

class GrillModeViewCell: CookControlsViewCell {
        
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        disposables.removeAll()
        
        if let selectorItem = data as? CookCellItem<CookMode> {
            selectorItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] cookMode in
                guard let self = self else { return }
                if let cookMode = cookMode {
                    self.cookModeIcon.image = CookDisplayValues.getModeImage(cookMode: cookMode)?.tint(color: self.theme().primaryTextColor)
                    self.titleLabel.text = CookDisplayValues.getModeDisplayName(cookMode: cookMode)
                }
            }.store(in: &disposables)
        }
    }
    
    @UsesAutoLayout var cookModeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.image = IconAssetLibrary.ico_mode_grill.asImage()?.tint(color: .white)
        return imageView
    }()
    
    @UsesAutoLayout var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "---"
        return label
    }()
    
    @UsesAutoLayout var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "COOK MODE".uppercased()
        return label
    }()
    
    @UsesAutoLayout var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.image = IconAssetLibrary.ico_arrow_right.asImage()?.tint(color: .white)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        // TODO: Final Monitor/Control Styling
        cookModeIcon.tintColor = ColorThemeManager.shared.theme.primaryForegroundColor
        titleLabel.setStyle(.cookCellTitleBold, theme: theme())
        subtitleLabel.setStyle(.cookCellInfo, theme: theme())
        arrowIcon.tintColor = theme().tertiaryWarmAccentColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        shadowContainer.addSubview(cookModeIcon)
        shadowContainer.addSubview(titleLabel)
        shadowContainer.addSubview(subtitleLabel)
        shadowContainer.addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            cookModeIcon.topAnchor.constraint(equalTo: shadowContainer.topAnchor, constant: 16),
            cookModeIcon.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: -16),
            cookModeIcon.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor, constant: 16),
            cookModeIcon.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: shadowContainer.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cookModeIcon.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: -16),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -8),
            
            arrowIcon.topAnchor.constraint(equalTo: shadowContainer.topAnchor, constant: 16),
            arrowIcon.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: -16),
            arrowIcon.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor, constant: 8),
            arrowIcon.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor, constant: -16)
        ])
    }
}
