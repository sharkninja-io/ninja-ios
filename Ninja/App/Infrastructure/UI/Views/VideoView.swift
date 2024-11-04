//
//  VideoView.swift
//  Ninja
//
//  Created by Martin Burch on 11/22/22.
//

import UIKit
import AVFoundation

class VideoView: BaseView {
    
    /// (VideoName, VideoExtension)
    var videoPath: String? {
        didSet {
            initVideoPlayer()
        }
    }
    
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    
    override func setupViews() {
        super.setupViews()
        
        initVideoPlayer()
    }
    
    private func initVideoPlayer() {
        guard let path = videoPath else { return }
        
        avPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        // Reverse of Black continue button
        avPlayerLayer?.backgroundColor = ColorThemeManager.shared.theme.white01.cgColor
        avPlayerLayer?.frame = self.bounds
        avPlayerLayer?.videoGravity = .resizeAspectFill
        
        guard let avPlayerLayer = avPlayerLayer else { return }
        self.layer.addSublayer(avPlayerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avPlayerLayer?.frame = self.bounds
    }
    
    func playVideo() {
        avPlayer?.play()
    }
    
    func pauseVideo() {
        avPlayer?.pause()
    }
}
