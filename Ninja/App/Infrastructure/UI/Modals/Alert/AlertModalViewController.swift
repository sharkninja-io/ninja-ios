//
//  AlertModalViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/20/22.
//

import Foundation
import UIKit

class AlertModalViewController: UIViewController {
    
    private let manager: AlertManager
    
    lazy var subview: AlertModalView = .init(frame: view.bounds)
    
    private var preventDismissal: Bool
    
//    /// Standard initializer. Only provided items will be included in the modal.
//    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, image: UIImage? = nil, primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil, dismissCallback: (() -> ())? = nil, preventDismissal: Bool = false) {
    /// Create an alert modal with the provided parameters
    /// - Parameters:
    ///   - topIcon: Image that appears at the top of the modal, above the title label.
    ///   - image: Image that appears underneath the modal text labels
    ///   - dismissCallback: Closure executed if the modal is dismissed without any action having been taken.
    ///   - preventDismissalWithoutAction: If `true`, disables tapping outside of the modal to dismiss. In which case the user *must* tap one of the buttons.
    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, image: UIImage? = nil, primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil, dismissCallback: (() -> ())? = nil, preventDismissalWithoutAction: Bool = false) {
        manager = .init(title: title, description: description, topIcon: topIcon, image: image, primaryAction: primaryAction, secondaryAction: secondaryAction, dismissCallback: dismissCallback)
        self.preventDismissal = preventDismissalWithoutAction
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    /// Initializer for if the modal is to display more than one image in a horizontal stack.
    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, images: [UIImage?], primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil, dismissCallback: (() -> ())? = nil, preventDismissal: Bool = false) {
        manager = .init(title: title, description: description, topIcon: topIcon, images: images, primaryAction: primaryAction, secondaryAction: secondaryAction, dismissCallback: dismissCallback)
        self.preventDismissal = preventDismissal
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    init(alertManager: AlertManager) {
        manager = alertManager
        self.preventDismissal = false
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = subview
        subview.applyAttributes(manager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        // Dismiss Actions
        if !preventDismissal { subview.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callbackAndDismiss))) }
        
        if let primary = manager.primaryAction {
            subview.primaryButton.onEvent() { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true) {
                    primary.alertAction()
                }
            }
        }
        
        if let secondary = manager.secondaryAction {
            subview.secondaryButton.onEvent() { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true) {
                    secondary.alertAction()
                }
            }
        }
    }
    
    @objc private func callbackAndDismiss() {
        if let callback = manager.dismissCallback {
            callback()
        }
        dismiss(animated: true)
    }
}
