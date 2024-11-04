//
//  PairingSplashView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PairingSplashView: BaseXIBView {
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var videoView: VideoView!
    @IBOutlet var imageView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        
        continueButton.setTitle("START", for: .normal)
        titleLabel.text = "Connect your Grill quickly"
        titleLabel.textAlignment = .center
        subtitleLabel.text = "so you can focus on what's important!"
        subtitleLabel.textAlignment = .center
        
//        videoView.videoPath = VideoAssetLibrary.splash_smoke_mp4.toBundlePath()
        imageView.image = ImageAssetLibrary.demo_pairing_screen.asImage()
//        imageView.isHidden = true
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        continueButton.setStyle(.blackButton)
        titleLabel.setStyle(.pairingSplashTitleLabel)
        subtitleLabel.setStyle(.pairingSplashInfoLabel)
     }
}
