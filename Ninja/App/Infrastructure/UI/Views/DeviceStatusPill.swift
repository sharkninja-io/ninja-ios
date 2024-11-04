//
//  DeviceStatusPill.swift
//  Ninja
//
//  Created by Martin Burch on 2/5/23.
//

import UIKit

class DeviceStatusPill: BaseView {
    
    var wifiOnline: Bool = false {
        didSet {
            setupPill()
        }
    }
    
    var bluetoothOnline: Bool = false {
        didSet {
            setupPill()
        }
    }
    
    var errorColor: UIColor = ColorThemeManager.shared.theme.grey02 {
        didSet {
            wifiOfflineIcon.tintColor = errorColor
            bluetoothOfflineIcon.tintColor = errorColor
            offlinePillView.layer.borderColor = errorColor.cgColor
            setNeedsDisplay()
        }
    }
    
    func setupPill() {
        offlineStatusLabel.isHidden = bluetoothOnline || wifiOnline
        bluetoothOnlineIcon.isHidden = !bluetoothOnline
        bluetoothOfflineIcon.isHidden = bluetoothOnline
        wifiOnlineIcon.isHidden = !wifiOnline
        wifiOfflineIcon.isHidden = wifiOnline
        onlinePillView.isHidden = !bluetoothOnline && !wifiOnline
        offlinePillView.isHidden = bluetoothOnline && wifiOnline
    }
    
    var onlineStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var wifiOnlineIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_wifi_online.asImage()?.tint(color: .white)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var bluetoothOnlineIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_bluetooth_online.asImage()?.tint(color: .white)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var offlineStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var wifiOfflineIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_wifi_offline.asTemplateImage()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var bluetoothOfflineIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_bluetooth_offline.asTemplateImage()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var onlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    var onlinePillView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorThemeManager.shared.theme.primaryAccentColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    var offlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()

    var offlinePillView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorThemeManager.shared.theme.primaryErrorForegroundColor.cgColor
        return view
    }()
    
    var pillStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        onlineStatusLabel.text = "ONLINE"
        offlineStatusLabel.text = "OFFLINE"
        wifiOfflineIcon.tintColor = errorColor
        bluetoothOfflineIcon.tintColor = errorColor
        offlinePillView.layer.borderColor = errorColor.cgColor
        setupPill()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        onlineStackView.addArrangedSubview(onlineStatusLabel)
        onlineStackView.addArrangedSubview(wifiOnlineIcon)
        onlineStackView.addArrangedSubview(bluetoothOnlineIcon)
        offlineStackView.addArrangedSubview(offlineStatusLabel)
        offlineStackView.addArrangedSubview(wifiOfflineIcon)
        offlineStackView.addArrangedSubview(bluetoothOfflineIcon)
        onlinePillView.addSubview(onlineStackView)
        offlinePillView.addSubview(offlineStackView)
        
        pillStack.addArrangedSubview(onlinePillView)
        pillStack.addArrangedSubview(offlinePillView)
        addSubview(pillStack)

        NSLayoutConstraint.activate([
            onlineStackView.topAnchor.constraint(equalTo: onlinePillView.topAnchor, constant: 6),
            onlineStackView.bottomAnchor.constraint(equalTo: onlinePillView.bottomAnchor, constant: -6),
            onlineStackView.leadingAnchor.constraint(equalTo: onlinePillView.leadingAnchor, constant: 6),
            onlineStackView.trailingAnchor.constraint(equalTo: onlinePillView.trailingAnchor, constant: -6),
            
            offlineStackView.topAnchor.constraint(equalTo: offlinePillView.topAnchor, constant: 6),
            offlineStackView.bottomAnchor.constraint(equalTo: offlinePillView.bottomAnchor, constant: -6),
            offlineStackView.leadingAnchor.constraint(equalTo: offlinePillView.leadingAnchor, constant: 6),
            offlineStackView.trailingAnchor.constraint(equalTo: offlinePillView.trailingAnchor, constant: -6),
            
            pillStack.topAnchor.constraint(equalTo: self.topAnchor),
            pillStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pillStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    override func refreshStyling() {
        self.backgroundColor = .clear
        
        onlinePillView.layer.cornerRadius = self.frame.height / 2
        offlinePillView.layer.cornerRadius = self.frame.height / 2
        onlineStatusLabel.setStyle(.cookPillStatus())
        offlineStatusLabel.setStyle(.cookPillStatus(textColor: errorColor))
    }
}
