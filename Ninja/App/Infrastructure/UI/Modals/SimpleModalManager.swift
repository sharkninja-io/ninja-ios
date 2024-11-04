//
//  SimpleModalManager.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/21/22.
//

import Foundation
import UIKit

class SimpleModalManager {
    var topIcon: UIImage?
    var title: String?
    var description: String?
    var image: UIImage?
    var dismissCallback: (() -> ())?
    
    var images: [UIImage?]? = nil
    
    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, image: UIImage? = nil, dismissCallback: (() -> ())? = nil) {
        self.topIcon = topIcon
        self.title = title
        self.description = description
        self.image = image
    }
    
    /// Initializer for if the modal is to display more than one image in a horizontal stack.
    init(title: String? = nil, description: String? = nil, topIcon: UIImage? = nil, images: [UIImage?], dismissCallback: (() -> ())? = nil) {
        self.topIcon = topIcon
        self.title = title
        self.description = description
        self.image = nil
        self.images = images
    }
}
