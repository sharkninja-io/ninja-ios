//
//  TermsAndConditionsViewController.swift
//  Ninja
//
//  Created by Martin Burch on 9/20/22.
//

import UIKit

class TermsAndConditionsViewController: BaseViewController<TermsAndConditionsView> {
        
    override func setupViews() {
        super.setupViews()
        
        subview.IAgreeButton.onEvent { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
}
