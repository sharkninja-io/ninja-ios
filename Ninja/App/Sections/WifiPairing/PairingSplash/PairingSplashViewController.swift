//
//  PairingSplashViewController.swift
//  Ninja
//
//  Created by Martin Burch on 11/21/22.
//

import UIKit

class PairingSplashViewController: BaseViewController<PairingSplashView> {
    
    override func setupViews() {
        super.setupViews()
        
        subview.continueButton.onEvent(closure: toNext(_:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subview.videoView.playVideo()
    }
    
    func toNext(_ control: UIControl) {
        subview.videoView.pauseVideo()
        navigationController?.pushViewController(PermissionPromptInfoViewController(), animated: true)
    }
}
