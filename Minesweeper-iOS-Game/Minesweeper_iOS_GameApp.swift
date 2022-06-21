//
//  Minesweeper_iOS_GameApp.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/24.
//

import SwiftUI
import FirebaseCore
import AVFoundation
import GoogleMobileAds

@main
struct Minesweeper_iOS_GameApp: App {
    
    @AppStorage("isBackgroundMusicOn") var isBackgroundMusicOn = true
    
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start()
        AVPlayer.setupBgMusic()
        if isBackgroundMusicOn {
            AVPlayer.bgQueuePlayer.play()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
