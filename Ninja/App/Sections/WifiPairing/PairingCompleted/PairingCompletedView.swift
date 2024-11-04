//
//  PairingCompletedView.swift
//  Ninja
//
//  Created by Martin Burch on 12/7/22.
//

import UIKit

class PairingCompletedView: BaseXIBView {
    
    @IBOutlet var activitySpinner: ActivityWorkingView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var continueButton: UIButton!
    
    var grillName: String = "" {
        didSet {
            infoLabel.text = """
            I'm your new cooking partner,
            \(grillName)
            """
            layoutIfNeeded()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Hello there!"
        imageView.image = ImageAssetLibrary.img_outdoor_pro_grill.asImage()
        continueButton.setTitle("LET'S GET STARTED", for: .normal)
        self.clipsToBounds = true
    }
    
    override func refreshStyling() {
        titleLabel.setStyle(.pairingPageTitleLabel)
        titleLabel.textAlignment = .center
        infoLabel.setStyle(.pairingLargestInfoLabel)
        infoLabel.textAlignment = .center
        continueButton.setStyle(.primaryButton)
    }
    
    func start() {
        activitySpinner.start()
    }
    
    func complete() {
        activitySpinner.complete()
    }
}
