//
//  LocalPlayerView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit
import AVFoundation

final class LocalPlayerView: UIView {
    var loop = false
    
    init(filename: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        
        guard let filePath = Bundle.main.path(forResource: filename, ofType: ".mp4") else {
            fatalError()
        }
        let item = AVPlayerItem(url: .init(fileURLWithPath: filePath))
        player = AVPlayer(playerItem: item)
        player.isMuted = true
        
        videoLayer = AVPlayerLayer(player: player).then {
            $0.videoGravity = .resizeAspectFill
            $0.shouldRasterize = true
            $0.rasterizationScale = UIScreen.main.scale
        }
        layer.addSublayer(videoLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = bounds
    }
    func pause() {
        player.pause()
    }
    func reset() {
        playCompletion = nil
        NotificationCenter.default.removeObserver(self)
        player.pause()
        player.seek(to: .zero)
    }
    
    func play(_ completion: (() -> Void)? = nil) {
        playCompletion = completion
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        AVAudioSession.sharedInstance().do {
            try? $0.setCategory(.ambient, options: [.mixWithOthers, .defaultToSpeaker])
            try? $0.setActive(true)
        }
    }
    
    @objc private func didPlayToEnd(_ noti: Notification) {
        guard let item = noti.object as? AVPlayerItem else { return }
        if item != player.currentItem { return }
        playCompletion?()
        player.pause()
        player.seek(to: .zero)
        guard loop else { return }
        player.play()
    }
    
    private var playCompletion: (() -> Void)?
    private(set) var player: AVPlayer!
    private unowned var videoLayer: AVPlayerLayer!
    
    private override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
