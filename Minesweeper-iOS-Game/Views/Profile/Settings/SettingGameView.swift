//
//  SettingGameView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/21.
//

import SwiftUI
import AVFoundation

struct SettingGameView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("isBackgroundMusicOn") var isBackgroundMusicOn = true
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Text("Game")
                
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(Image(systemName: "chevron.backward"))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
            }
            .font(.title2.bold())
            .padding(.vertical, 5)
            
            Divider()
            
            Text("Game Settings")
                .font(.title3.bold())
                .padding(.vertical)
            
            Toggle(isOn: $isBackgroundMusicOn) {
                Text("Music")
                    .font(.title3)
            }
            .onChange(of: isBackgroundMusicOn) { _ in
                if isBackgroundMusicOn {
                    AVPlayer.bgQueuePlayer.play()
                } else {
                    AVPlayer.bgQueuePlayer.pause()
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .background(Color(red: 185/255, green: 221/255, blue: 118/255))
    }
}
