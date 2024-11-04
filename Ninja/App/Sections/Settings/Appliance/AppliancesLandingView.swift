//
//  AppliancesLandingView.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 9/27/22.
//

import UIKit

class AppliancesLandingView: BaseView {
    
    public var appliancesPresent: Bool = true {
        didSet {
            if appliancesPresent {
                setupAppliancesPresent()
            } else {
                setupNoAppliances()
            }
        }
    }
    
    @UsesAutoLayout public var titleLabel = UILabel()
    @UsesAutoLayout public var addApplianceButton = UIButton()
    
    // Appliances
    @UsesAutoLayout public var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var appliancesPresentConstraints: [NSLayoutConstraint] = [
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: addApplianceButton.topAnchor, constant: -12),
    ]
    
    // No Appliances
    @UsesAutoLayout private var grillImage = UIImageView()
    @UsesAutoLayout private var grillDescriptionLabel = UILabel()
    private lazy var noAppliancesConstraints: [NSLayoutConstraint] = [
        grillImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
        grillImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        
        // Adjust for grill not being vertically centered
        grillImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -40),
        
        // Adjust for extra empty space in grill image
        grillDescriptionLabel.topAnchor.constraint(equalTo: grillImage.bottomAnchor, constant: -110),
        grillDescriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
        grillDescriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding)
    ]
        
    override func setupViews() {
        collectionView.register(ApplianceCollectionViewCell.self, forCellWithReuseIdentifier: ApplianceCollectionViewCell.VIEW_ID)
        
        titleLabel.text = "Your Appliances"
        addApplianceButton.setTitle("Add Another Appliance".uppercased(), for: .normal)
        
        grillImage.image = ImageAssetLibrary.img_ogxl_angled.asImage()
        grillImage.contentMode = .scaleAspectFit
        grillDescriptionLabel.setStyle(.settingsDescriptionLabel)
        grillDescriptionLabel.text = "It seems like there's no appliance paired yet. You can add a new one and start monitoring your cooking sessions from your device."
    }
    
    override func setupConstraints() {
        addSubview(titleLabel)
        addSubview(addApplianceButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DefaultSizes.topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DefaultSizes.leadingPadding),
            
            addApplianceButton.heightAnchor.constraint(equalToConstant: 48),
            addApplianceButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DefaultSizes.leadingPadding),
            addApplianceButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: DefaultSizes.trailingPadding),
            addApplianceButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32)

        ])
    }
        
    override func refreshStyling() {
        backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        titleLabel.setStyle(.titleLabel)
        grillDescriptionLabel.setStyle(.settingsDescriptionLabel)
        
        collectionView.backgroundColor = ColorThemeManager.shared.theme.primaryBackgroundColor
        
        addApplianceButton.setStyle(.destructiveTertiaryButton)
    }
    
    private func setupAppliancesPresent() {
        NSLayoutConstraint.deactivate(noAppliancesConstraints)
        
        grillImage.removeFromSuperview()
        grillDescriptionLabel.removeFromSuperview()
        addSubview(collectionView)
        
        NSLayoutConstraint.activate(appliancesPresentConstraints)
    }
    
    private func setupNoAppliances() {
        NSLayoutConstraint.deactivate(appliancesPresentConstraints)
        
        collectionView.removeFromSuperview()
        addSubview(grillImage)
        addSubview(grillDescriptionLabel)
        
        NSLayoutConstraint.activate(noAppliancesConstraints)
    }
    

}

