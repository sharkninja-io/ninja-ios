//
//  DeletingAccountLoadingView.swift
//  Ninja
//
//  Created by Richard Jacobson on 12/16/22.
//

import UIKit

class DeletingAccountLoadingView: BaseView {
    
    @UsesAutoLayout var activityView = ActivityWorkingView()
    @UsesAutoLayout var messagelabel = UILabel()
    @UsesAutoLayout var continueButton = UIButton()
    
    override func setupViews() {
        activityView.clipsToBounds = true
        continueButton.setTitle("Continue".uppercased(), for: .normal)
        continueButton.isHidden = true
    }
    
    override func setupConstraints() {
        addSubview(activityView)
        addSubview(messagelabel)
        addSubview(continueButton)
        
        NSLayoutConstraint.activate(activityView.constraintsForAnchoringTo(boundsOf: self))
        NSLayoutConstraint.activate([
            messagelabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DefaultSizes.topPadding),
            messagelabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            messagelabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            
            continueButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            continueButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            continueButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func refreshStyling() {
        backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        messagelabel.setStyle(.settingsSubtitle)
        continueButton.setStyle(.primaryButton)
    }
}
