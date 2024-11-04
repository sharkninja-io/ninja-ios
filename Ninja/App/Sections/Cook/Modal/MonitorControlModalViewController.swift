//
//  MonitorControlModals.swift
//  Ninja
//
//  Created by Martin Burch on 3/9/23.
//

import UIKit

class MonitorControlModalViewController: BaseViewController<MonitorControlModalView> {
    
    var modalTitle: String?
    var modalDescription: String?
    var primaryButtonText: String?
    var secondaryButtonText: String?
    var primaryButtonIcon: UIImage?
    var secondaryButtonIcon: UIImage?
    var successCompletion: (() -> Void)?
    var cancelCompletion: (() -> Void)?
    
    var theme: () -> ColorTheme = { ColorThemeManager.shared.theme }
    var isWarning = false
    
    override func setupViews() {
        super.setupViews()
        
        subview.primaryButton.onEvent { [weak self] _ in
            guard let self = self else { return }
            self.confirm()
        }
        subview.secondaryButton.onEvent { [weak self] _ in
            guard let self = self else { return }
            self.toCancel()
        }
        
        subview.titleLabel.text = modalTitle
        subview.descriptionLabel.text = modalDescription
        subview.primaryButton.setTitle(primaryButtonText, for: .normal)
        subview.primaryButton.setImage(primaryButtonIcon, for: .normal)
        if secondaryButtonText == nil && secondaryButtonIcon == nil {
            subview.showSecondaryButton = false
        } else {
            subview.secondaryButton.setTitle(secondaryButtonText, for: .normal)
            subview.secondaryButton.setImage(secondaryButtonIcon, for: .normal)
        }
        subview.theme = theme
        subview.primaryButtonStyle = isWarning ? .coloredButton(foregroundColor: theme().white01, backgroundColor: theme().quaternaryWarmAccentColor) : .primaryButton
    }
    
    func confirm() {
        successCompletion?()
        self.dismiss(animated: true)
    }
    
    func toCancel() {
        cancelCompletion?()
        self.dismiss(animated: true)
    }
    
}
