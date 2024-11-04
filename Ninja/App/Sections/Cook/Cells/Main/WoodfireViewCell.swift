//
//  CookViewCell.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit

class WoodfireViewCell: CookControlsViewCell {
    
    override func connectData(data: CookItem) {
        super.connectData(data: data)
        
        disposables.removeAll()
        
        if let dataItem = data as? CookCellItem<Bool> {
            dataItem.currentValueSubject.receive(on: DispatchQueue.main).sink { [weak self] isOn in
                if let isOn = isOn {
                    self?.toggle.setOn(isOn, animated: true)
                    self?.info.text = isOn ? "Activated".uppercased() : "Off".uppercased()
                }
            }.store(in: &disposables)
            dataItem.enabledSubject?.receive(on: DispatchQueue.main).sink { [weak self] isEnabled in
                self?.toggle.isEnabled = isEnabled
            }.store(in: &disposables)
            
            toggle.removeEvent()
            toggle.onEvent { [weak self] control in
                guard let self = self else { return }
                if dataItem.currentValueSubject.value != self.toggle.isOn {
                    dataItem.onClick?(control, self.toggle.isOn)
                    dataItem.currentValueSubject.send(self.toggle.isOn)
                }
            }
        }
    }
    
    var icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = IconAssetLibrary.ico_woodfire.asImage()?.tint(color: ColorThemeManager.shared.theme.grey01)
        image.contentMode = .scaleAspectFit
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return image
    }()
    
    var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var info: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var toggle: UISwitch = {
        let tg = UISwitch()
        tg.translatesAutoresizingMaskIntoConstraints = false
        tg.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return tg
    }()
    
    override func setupViews() {
        super.setupViews()
                
        title.text = "Woodfire flavor technology"
        info.text = "OFF".uppercased()
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        title.setStyle(.cookCellTitleBoldAdjustable, theme: theme())
        info.setStyle(.cookCellInfo, theme: theme())
        icon.image = IconAssetLibrary.ico_woodfire.asImage()?.tint(color: theme().secondaryTextColor)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        shadowContainer.addSubview(icon)
        shadowContainer.addSubview(title)
        shadowContainer.addSubview(info)
        shadowContainer.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: self.shadowContainer.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: self.shadowContainer.leadingAnchor, constant: 16),
            icon.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant: -8),
            
            title.topAnchor.constraint(equalTo: self.shadowContainer.topAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: info.topAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -8),

            info.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            info.bottomAnchor.constraint(equalTo: self.shadowContainer.bottomAnchor, constant: -16),
            info.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            info.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -8),

            toggle.topAnchor.constraint(equalTo: self.shadowContainer.topAnchor, constant: 20),
            toggle.bottomAnchor.constraint(equalTo: self.shadowContainer.bottomAnchor, constant: -20),
            toggle.leadingAnchor.constraint(equalTo: info.trailingAnchor, constant: 8),
            toggle.trailingAnchor.constraint(equalTo: self.shadowContainer.trailingAnchor, constant: -24),

        ])
    }
}
