//
//  ProfileView.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/14/22.
//
import UIKit

class ProfileView: SettingsStandardTableView {
    
    @UsesAutoLayout var saveChangesButton = UIButton()
    
    override func setupViews() {
        scrollView.pinToAnchors(top: safeAreaLayoutGuide.topAnchor,
                                leading: safeAreaLayoutGuide.leadingAnchor,
                                trailing: safeAreaLayoutGuide.trailingAnchor,
                                bottom: saveChangesButton.topAnchor,
                                superView: self,
                                withContentView: contentView) { [weak self] in guard let self else { return }
            self.contentView.addSubview(self.vStack)
            self.contentView.addSubview(self.tableView)
            self.addSubview(self.saveChangesButton)
        }
        
        tableView.register(ProfileTextFieldCell.self, forCellReuseIdentifier: ProfileTextFieldCell.VIEW_ID)
        tableView.register(ProfileFooterCell.self, forCellReuseIdentifier: ProfileFooterCell.VIEW_ID)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        saveChangesButton.setTitle("Save Changes".uppercased(), for: .normal)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DefaultSizes.topPadding),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DefaultSizes.leadingPadding),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            tableView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: DefaultSizes.bottomPadding),
            
            saveChangesButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveChangesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DefaultSizes.leadingPadding),
            saveChangesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: DefaultSizes.trailingPadding),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        saveChangesButton.setStyle(.primaryButton)
    }
}
