//
//  SplashViewController.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/21/22.
//

import UIKit
import Combine

class SplashViewController: BaseViewController<SplashView> {
    
    var animationCompletion: (() -> Void)? = nil
    
    override func viewDidLoad() {
        subview.start {
            self.animationCompletion?()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
