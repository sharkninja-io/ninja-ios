//
//  BTWifiSelectionViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 1/11/23.
//

import UIKit
import GrillCore

class BTWifiSelectionViewCell: BaseTableViewCell {
    
    var wifiNetwork: CloudCoreSDK.WifiNetwork? = nil
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var lockedIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_wifi_lock.asImage()
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return image
    }()
    
    var strengthIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_wifi_bars_1.asImage()
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return image
    }()
    
    func setWifiStrength(strength: Int8) {
        switch strength {
        case 0, 1:
            strengthIcon.image = IconAssetLibrary.ico_wifi_bars_1.asImage()
        case 2, 3:
            strengthIcon.image = IconAssetLibrary.ico_wifi_bars_2.asImage()
        default:
            strengthIcon.image = IconAssetLibrary.ico_wifi_bars_3.asImage()
        }
        layoutIfNeeded()
    }
    
    func setSecured(isSecured: Bool) {
        lockedIcon.isHidden = !isSecured
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        nameLabel.setStyle(.pairingWifiItemLabel)
        lockedIcon.tintColor = ColorThemeManager.shared.theme.grey01 // 555555
    }
    
    override func setupConstraints() {
        addSubview(nameLabel)
        addSubview(lockedIcon)
        addSubview(strengthIcon)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: lockedIcon.leadingAnchor, constant: -8),

            lockedIcon.heightAnchor.constraint(equalToConstant: 16),
            lockedIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            lockedIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            lockedIcon.trailingAnchor.constraint(equalTo: strengthIcon.leadingAnchor, constant: -8),

            strengthIcon.heightAnchor.constraint(equalToConstant: 16),
            strengthIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            strengthIcon.leadingAnchor.constraint(equalTo: lockedIcon.trailingAnchor, constant: 8),
            strengthIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),

        ])
    }
}
