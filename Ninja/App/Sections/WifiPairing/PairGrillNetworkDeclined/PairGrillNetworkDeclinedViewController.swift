//
//  DeclinedNetworkViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PairGrillNetworkDeclinedViewController: BaseViewController<PairGrillNetworkDeclinedView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.continueButton.onEvent(closure: toNext(_:))
        
        navigationItem.hidesBackButton = true
    }
    
    func toNext(_ control: UIControl) {
        navigationController?.popToViewController(toControllerType: PairGrillHotspotViewController.self, animated: true)
    }

}
