//
//  TermsAndConditionsView.swift
//  Ninja
//
//  Created by Martin Burch on 9/20/22.
//

import UIKit

class TermsAndConditionsView: BaseXIBView {
    
    @IBOutlet var IAgreeButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        IAgreeButton.setTitle("OK", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        IAgreeButton.setStyle(.primaryButton)
    }
}
