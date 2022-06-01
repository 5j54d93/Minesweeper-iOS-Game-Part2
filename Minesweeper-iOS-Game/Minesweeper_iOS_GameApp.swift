//
//  Minesweeper_iOS_GameApp.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/24.
//

import SwiftUI
import FirebaseCore

@main
struct Minesweeper_iOS_GameApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
