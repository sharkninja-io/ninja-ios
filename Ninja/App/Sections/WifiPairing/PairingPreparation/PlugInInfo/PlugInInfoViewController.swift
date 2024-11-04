//
//  PlugInInfoViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PlugInInfoViewController: BaseViewController<PlugInInfoView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.dismissButton.onEvent { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

}
