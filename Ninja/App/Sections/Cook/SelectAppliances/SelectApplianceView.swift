//
//  SelectApplianceView.swift
//  Ninja
//
//  Created by Rahul Sharma on 1/16/23.
//

import UIKit

class SelectApplianceView: BaseXIBView {
    
    @IBOutlet weak var topMask: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var navBar: DeviceNavBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    let cellHeightConstant: CGFloat = 40
    
    let tapToDismissView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        tableView.clipsToBounds = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.register(SelectApplianceCell.self, forCellReuseIdentifier: SelectApplianceCell.VIEW_ID)

        tableView.layer.cornerRadius = 12
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = ColorThemeManager.shared.theme.grey04.cgColor
        tableView.tableFooterView = UIView()
        
        navBar.showBackButton = false
        
        addSubview(tapToDismissView)
    
        NSLayoutConstraint.activate([
            tapToDismissView.topAnchor.constraint(equalTo: container.bottomAnchor),
            tapToDismissView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tapToDismissView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tapToDismissView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    override func refreshStyling() {
        self.backgroundColor = ColorThemeManager.shared.theme.grey01.withAlphaComponent(0.7)
        container.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        topMask.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        navBar.deviceButton.setStyle(.dropdownButtonSelected)

    }
}
