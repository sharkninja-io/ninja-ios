//
//  DeviceNavBar.swift
//  Ninja
//
//  Created by Martin Burch on 2/5/23.
//

import UIKit


class DeviceNavBar: BaseView {
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    
    var showBackButton: Bool = false {
        didSet {
            backButton.isHidden = !showBackButton
        }
    }
    
    var showDeviceButton: Bool = true {
        didSet {
            deviceButton.isHidden = !showDeviceButton
        }
    }
    
    lazy var pillView: DeviceStatusPill = {
        let pv = DeviceStatusPill()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    lazy var deviceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("---", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        return button
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    func setSelectedDeviceName(name: String) {
        deviceButton.setTitle(name, for: .normal)
    }

    override func setupViews() {
        super.setupViews()
        
//        deviceButton.addTarget(self, action: #selector(self.didExpandAppliances), for: .touchUpInside)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(deviceButton)
        stackView.addArrangedSubview(pillView)
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    override func refreshStyling() {
        self.backgroundColor = theme().primaryBackgroundColor
        
        deviceButton.setStyle(.dropdownButton, theme: theme())
        backButton.setStyle(.navBackButton, theme: theme())
    }
//
//    @objc func didExpandAppliances() {
//        let vc = UINavigationController(rootViewController: SelectAppliancesViewController())
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
}
