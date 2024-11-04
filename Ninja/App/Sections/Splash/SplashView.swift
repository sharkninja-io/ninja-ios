//
//  SplashView.swift
//  Ninja - Unstable
//
//  Created by Martin Burch on 10/21/22.
//

import UIKit

class SplashView: UIView {
    
    private let theme = ColorThemeManager.shared.theme
    
    var videoView: VideoView = {
        let video = VideoView()
        video.translatesAutoresizingMaskIntoConstraints = false
        video.videoPath = VideoAssetLibrary.splash_smoke_mp4.toBundlePath()
        video.layer.opacity = 1
        return video
    }()
    
    var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = ImageAssetLibrary.splash_ninja_logo.asImage()?.tint(color: .white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
//    var grillView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = ImageAssetLibrary.img_outdoor_pro_grill.asImage()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
//    var blobView: BlobView = {
//        let blob = BlobView()
//        blob.translatesAutoresizingMaskIntoConstraints = false
//        return blob
//    }()
    
    func start(completion: @escaping () -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            videoView.playVideo()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self?.grillView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.5, animations: { [weak self] in
                        self?.videoView.layer.opacity = 0
                        self?.backgroundColor = self?.theme.primaryBackgroundColor
                    }, completion: { _ in completion() })
                }
//            }
//        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        self.backgroundColor = theme.black01
        videoView.backgroundColor = theme.black01
    }
    
    private func setupConstraints() {
//        self.addSubview(blobView)
        self.addSubview(videoView)
        self.addSubview(logoView)
//        addSubview(grillView)
        
        NSLayoutConstraint.activate([
//            blobView.topAnchor.constraint(equalTo: self.topAnchor),
//            blobView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            blobView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            blobView.trailing.constraint(equalTo: self.topAnchor),
            videoView.topAnchor.constraint(equalTo: self.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64),
            logoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -64),
//            grillView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            grillView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -200),
        ])
    }
}
