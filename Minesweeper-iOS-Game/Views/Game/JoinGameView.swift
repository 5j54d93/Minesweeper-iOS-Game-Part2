//
//  JoinGameView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/13.
//

import SwiftUI
import GoogleMobileAds

struct JoinGameView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    
    @StateObject var gameViewModel = GameViewModel()
    
    @State private var roomCode = ""
    @State private var ad: GADRewardedAd?
    
    var body: some View {
        if !gameViewModel.game.isGameStart {
            if !gameViewModel.isInRoom {
                VStack {
                    HStack {
                        Text("Minesweeper")
                            .font(.largeTitle.bold())
                        
                        Spacer()
                    }
                    .padding(.bottom).padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color(red: 74/255, green: 117/255, blue: 44/255))
                    .padding(.bottom)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button {
                            gameViewModel.createAGame()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: nil, height: 140)
                                    .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                    .cornerRadius(5)
                                
                                VStack(spacing: 15) {
                                    Text("Create a game")
                                        .font(.title.bold())
                                        .foregroundColor(.black)
                                    
                                    Text("Set up your own game and invite your friends by sharing a code.")
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 25)
                                }
                            }
                        }
                        
                        ZStack {
                            Rectangle()
                                .frame(width: nil, height: 260)
                                .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                .cornerRadius(5)
                            
                            VStack(spacing: 15) {
                                Text("Join a game")
                                    .font(.title.bold())
                                    .foregroundColor(.black)
                                
                                Text("Enter code sent to you by a friend, and join their game.")
                                    .multilineTextAlignment(.center)
                                
                                TextField("Room code", text: $roomCode, prompt: Text("Room code"))
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color(red: 190/255, green: 225/255, blue: 125/255))
                                    .cornerRadius(5)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(.horizontal)
                                
                                Button {
                                    gameViewModel.joinRoom(id: roomCode)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(red: 74/255, green: 117/255, blue: 44/255), lineWidth: 1)
                                            .frame(width: nil, height: 40)
                                        
                                        Text("Join")
                                            .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
                                            .bold()
                                            .frame(width: nil)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        Button {
                            showAd()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                    .frame(width: nil, height: 60)
                                
                                Text("Get Reward")
                                    .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
                                    .font(.title.bold())
                                    .frame(width: nil)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .onAppear {
                    loadAd()
                }
            } else {
                VStack {
                    HStack {
                        Text("Minesweeper")
                            .font(.largeTitle.bold())
                        
                        Spacer()
                    }
                    .padding(.bottom).padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color(red: 74/255, green: 117/255, blue: 44/255))
                    .padding(.bottom, 15)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Button {
                                gameViewModel.exitRoom(id: gameViewModel.game.id!)
                            } label: {
                                Label("Back", systemImage: "chevron.backward")
                            }
                            
                            Spacer()
                        }
                        .font(.title2.bold())
                        
                        ZStack {
                            Rectangle()
                                .frame(width: nil, height: 45)
                                .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                .cornerRadius(5)
                            
                            Text("Room code: " + gameViewModel.game.id!)
                                .font(.title2.bold())
                                .foregroundColor(.black)
                        }
                        
                        ForEach(gameViewModel.players, id: \.self) { player in
                            ZStack {
                                Rectangle()
                                    .frame(width: nil, height: 120)
                                    .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                    .cornerRadius(5)
                                
                                HStack(spacing: 25) {
                                    AsyncImage(url: URL(string: player.avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color(red: 162/255, green: 209/255, blue: 72/255)
                                    }
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    
                                    Text(player.name)
                                        .font(.title.bold())
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        gameViewModel.gameStart()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: nil, height: 60)
                                .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                .cornerRadius(5)
                            
                            Text("Game start")
                                .font(.title2.bold())
                                .foregroundColor(.black)
                        }
                    }
                    .disabled(gameViewModel.players.count<2)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .onAppear {
                    gameViewModel.listenToUserDataChange(id: gameViewModel.game.id!)
                }
            }
        } else {
            GameView(authViewModel: authViewModel, userViewModel: userViewModel, gameViewModel: gameViewModel)
        }
    }
    
    func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) {ad, error in
            if error != nil {
                loadAd()
            }
            self.ad = ad
        }
    }
    
    func showAd() {
        if let ad = ad, let controller = UIViewController.getLastPresentedViewController() {
            ad.present(fromRootViewController: controller) {
                userViewModel.getReward()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}
