//
//  PressStartInfoViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PressStartInfoViewController: BaseViewController<PressStartInfoView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.dismissButton.onEvent { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

}
