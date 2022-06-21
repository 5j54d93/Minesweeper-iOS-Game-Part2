//
//  GameView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/14.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    @ObservedObject var gameViewModel : GameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Minesweeper")
                    .font(.largeTitle.bold())
                
                Spacer()
            }
            .padding(.bottom).padding(.horizontal)
            .foregroundColor(.white)
            .background(Color(red: 74/255, green: 117/255, blue: 44/255))
            
            ZStack {
                Rectangle()
                    .frame(width: nil, height: 130)
                    .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                    .cornerRadius(5)
                
                HStack {
                    Spacer()
                    ForEach(gameViewModel.players, id: \.self) { player in
                        VStack {
                            AsyncImage(url: URL(string: player.avatarUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color(red: 162/255, green: 209/255, blue: 72/255)
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(red: 74/255, green: 117/255, blue: 44/255), lineWidth: gameViewModel.game.playersId[gameViewModel.game.turn] == player.id ? 3 : 0))
                            
                            Text(player.name)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 7), spacing: 4) {
                ForEach(0..<49) { index in
                    GeometryReader { geo in
                        withAnimation(.linear(duration: 0.4)) {
                            Rectangle()
                                .frame(width: nil, height: geo.size.width)
                                .foregroundColor(gameViewModel.game.grids[index].foregroundColor)
                                .cornerRadius(8)
                                .overlay {
                                    if gameViewModel.game.grids[index].gridType == .bomb {
                                        Image(systemName: "circle.square.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color(red: 40/255, green: 124/255, blue: 205/255))
                                            .shadow(color: Color(red: 187/255, green: 174/255, blue: 161/255), radius: 2)
                                            .padding(8)
                                    } else if gameViewModel.game.grids[index].gridType == .number {
                                        Image(systemName: "\(gameViewModel.game.grids[index].num).square.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.red)
                                            .shadow(color: Color(red: 187/255, green: 174/255, blue: 161/255), radius: 2)
                                            .padding(8)
                                    }
                                }
                                .onTapGesture {
                                    if gameViewModel.game.playersId[gameViewModel.game.turn] == authViewModel.getId() {
                                        gameViewModel.tapGrid(index: index)
                                    }
                                }
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                }
            }
            .padding(12)
            .background(Color(red: 74/255, green: 117/255, blue: 44/255))
            .cornerRadius(5)
            .padding(.horizontal)
            
            ForEach(gameViewModel.players) { player in
                if player.id == gameViewModel.game.playersId[gameViewModel.game.turn] {
                    if player.id == authViewModel.getId() {
                        Text("Your turn")
                            .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
                            .font(.title.bold())
                            .padding(.vertical)
                    } else {
                        Text(player.name + "'s turn")
                            .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
                            .font(.title.bold())
                            .padding(.vertical)
                    }
                }
            }
            
            Spacer()
        }
        .alert(gameViewModel.game.loserId != authViewModel.getId() ? "You win" : "You lose", isPresented: $gameViewModel.game.isGameEnd) {
            Button("OK") {
                userViewModel.updateScore(ids: gameViewModel.game.playersId, loserId: gameViewModel.game.loserId)
                gameViewModel.endGame()
            }
        }
    }
}
