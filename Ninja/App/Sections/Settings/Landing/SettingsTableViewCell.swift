//
//  SettingsTableViewCell.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/18/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    private var settingsItem: SettingsViewItem?
    
    // Left side
    @UsesAutoLayout private var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    @UsesAutoLayout private var titleLabel = UILabel()
    @UsesAutoLayout private var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // Right side
    @UsesAutoLayout private var arrowIcon: UIImageView = {
        let view = UIImageView()
        view.image = IconAssetLibrary.ico_arrow_right.asImage() ?? UIImage()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()
    @UsesAutoLayout public var settingSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isEnabled = true
        return toggle
    }()
    
    // Alternate layouts
    private lazy var standardConstraints: [NSLayoutConstraint] = [
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ]
    private lazy var detailedConstraints: [NSLayoutConstraint] = [
        // Using a stack view wasn't matching the design consistently enough, so these are being laid out manually.
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        titleLabel.bottomAnchor.constraint(equalTo: detailLabel.topAnchor, constant: -8),
        detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
        detailLabel.leadingAnchor.constraint(equalTo: icon.leadingAnchor),
        detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -64) // Prevent label from colliding with right-side items
    ]
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshStyling()
    }
    
    private func setupViews() {
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        selectedBackgroundView = UIImageView(image: ColorThemeManager.shared.theme.tertiaryAccentColor.toImage())
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(standardConstraints)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
        ])
    }
    
    private func refreshStyling() {
        backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        titleLabel.setStyle(.settingsCellTitle)
        detailLabel.setStyle(.settingsCellDetail)
        
        icon.tintColor = settingsItem?.iconTint ?? ColorThemeManager.shared.theme.primaryAccentColor
        arrowIcon.tintColor = ColorThemeManager.shared.theme.primaryTextColor
    }
    
    public func connectData(_ item: SettingsViewItem) {
        arrowIcon.removeFromSuperview()
        settingSwitch.removeFromSuperview()
        detailLabel.removeFromSuperview()

        settingsItem = item
        titleLabel.text = item.title
        icon.image = item.icon.withRenderingMode(.alwaysTemplate)
        
        // Add detail label and layout if applicable
        if let detail = item.description {
            detailLabel.text = detail
            contentView.addSubview(detailLabel)
            NSLayoutConstraint.deactivate(standardConstraints)
            NSLayoutConstraint.activate(detailedConstraints)
        } else {
            NSLayoutConstraint.deactivate(detailedConstraints)
            NSLayoutConstraint.activate(standardConstraints)
        }
        
        // Add right-side item if applicable
        var newView: UIView?
        switch item.itemStyle {
        case .navigationLink:
            selectionStyle = .default
            newView = arrowIcon
        case .toggle:
            selectionStyle = .none
            newView = settingSwitch
        case .none:
            break
        }
        
        guard let newView else { return }
        contentView.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.centerYAnchor.constraint(equalTo: centerYAnchor),
            newView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            titleLabel.trailingAnchor.constraint(equalTo: newView.leadingAnchor, constant: -16)
        ])
    }
    
}
