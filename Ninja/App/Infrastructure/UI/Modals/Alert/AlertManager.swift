//
//  AlertManager.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/20/22.
//

import Foundation
import UIKit

class AlertManager: SimpleModalManager {
    var primaryAction: AlertAction?
    var secondaryAction: AlertAction?
    
    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, image: UIImage? = nil, primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil, dismissCallback: (() -> ())? = nil) {
        super.init(title: title, description: description, topIcon: topIcon, image: image, dismissCallback: dismissCallback)
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    /// Initializer for if the modal is to display more than one image in a horizontal stack.
    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, images: [UIImage?], primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil, dismissCallback: (() -> ())? = nil) {
        super.init(title: title, description: description, topIcon: topIcon, images: images, dismissCallback: dismissCallback)
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}

struct AlertAction {
    let title: String
    let buttonStyle: ButtonStyle
    public var alertAction: (() -> ())
    
    init(title: String, buttonStyle: ButtonStyle = .primaryButton, alertAction: @escaping (() -> ())) {
        self.title = title
        self.buttonStyle = buttonStyle
        self.alertAction = alertAction
    }
}
