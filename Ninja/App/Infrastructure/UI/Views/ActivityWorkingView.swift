//
//  ActivitySpinnerView.swift
//  Ninja
//
//  Created by Martin Burch on 11/16/22.
//

import UIKit

@IBDesignable
class ActivityWorkingView: BaseView {
    
    var overlayColor: UIColor = ColorThemeManager.shared.theme.primaryBackgroundColor
    
    var activitySpinner: ActivitySpinner = {
        let spinner = ActivitySpinner()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = ColorThemeManager.shared.theme.primaryAccentColor
        return spinner
    }()
        
    var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = IconAssetLibrary.ico_checkmark_circle_fill.asImage()
        imageView.tintColor = ColorThemeManager.shared.theme.primaryAccentColor
        imageView.isHidden = true
        return imageView
    }()
    
    var blobView: BlobView = {
        let blob = BlobView()
        blob.translatesAutoresizingMaskIntoConstraints = false
        blob.fillColor = ColorThemeManager.shared.theme.primaryAccentColor
        blob.isHidden = true
        return blob
    }()
    
    func start() {
        checkImageView.isHidden = true
        blobView.isHidden = true
        activitySpinner.isHidden = false
        activitySpinner.start()
        blobView.initializeBlob(frame: self.frame)
    }
    
    func stop() {
        activitySpinner.stop()
        activitySpinner.isHidden = true
    }
    
    func complete(duration: TimeInterval = 1, scaleToZero: Bool = false, completion: (() -> Void)? = nil) {
        checkImageView.isHidden = false
        
        UIView.animate(withDuration: duration * 0.5, animations: { [weak self] in
            self?.checkImageView.transform = CGAffineTransformMakeScale(2, 2)
        }) { [weak self] _ in
            UIView.animate(withDuration: duration * 0.5, animations: { [weak self] in
                self?.checkImageView.transform = scaleToZero ?
                    CGAffineTransformMakeScale(0.01, 0.01) : CGAffineTransformMakeScale(1, 1)
            }) { _ in
                completion?()
            }
        }
        stop()
    }
    
    func animateOut(duration: TimeInterval = 4, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.blobView.isHidden = false
            self?.blobView.animate(duration: duration) {
                self?.checkImageView.isHidden = true
                completion?()
            }
        }
    }
    
    override func refreshStyling() {
        self.backgroundColor = overlayColor
        activitySpinner.color = ColorThemeManager.shared.theme.primaryAccentColor
        checkImageView.tintColor = ColorThemeManager.shared.theme.primaryAccentColor
        blobView.fillColor = ColorThemeManager.shared.theme.primaryAccentColor
    }
    
    override func setupConstraints() {
        addSubview(activitySpinner)
        addSubview(checkImageView)
        addSubview(blobView)
        
        NSLayoutConstraint.activate([
            activitySpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activitySpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activitySpinner.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            activitySpinner.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),

            checkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            checkImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            
            blobView.topAnchor.constraint(equalTo: self.topAnchor),
            blobView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blobView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blobView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
