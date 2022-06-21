//
//  AVPlayer+Extensions.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/21.
//

import Foundation
import AVFoundation

extension AVPlayer {
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!

    static func setupBgMusic() {
        guard let url = Bundle.main.url(forResource: "Wishful Thinking - Dan Lebowitz", withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}
