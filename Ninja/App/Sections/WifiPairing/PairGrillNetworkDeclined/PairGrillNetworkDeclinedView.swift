//
//  DeclinedNetworkView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit

class PairGrillNetworkDeclinedView: BaseXIBView {
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var continueButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        
        pageTitleLabel.text = "CONNECTION TO APPLIANCE"
        titleLabel.text = "Whoops, You declined to join the appliance network!"
        infoLabel.text = "When prompted, allow your mobile device to connect to <Appliance name>'s Wi-Fi network."
        imageView.image = ImageAssetLibrary.img_screen_cancel_join.asImage()
        continueButton.setTitle("TRY AGAIN", for: .normal)
    }
    
    override func refreshStyling() {
        super.refreshStyling()
        
        pageTitleLabel.setStyle(.pairingPageTitleLabel)
        titleLabel.setStyle(.pairingTitleLabel)
        infoLabel.setStyle(.pairingLargestInfoLabel)
        continueButton.setStyle(.primaryButton)
    
    }
}
