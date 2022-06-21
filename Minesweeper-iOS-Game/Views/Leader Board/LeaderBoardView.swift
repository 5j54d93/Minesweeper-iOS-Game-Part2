//
//  LeaderBoardView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/14.
//

import SwiftUI

struct LeaderBoardView: View {
    
    @ObservedObject var userViewModel : UserViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Leader Board")
                    .font(.largeTitle.bold())
                
                Spacer()
            }
            .padding(.bottom).padding(.horizontal)
            .foregroundColor(.white)
            .background(Color(red: 74/255, green: 117/255, blue: 44/255))
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
                    .frame(width: nil, height: 40)
                
                Label("Win Time", systemImage: "crown.fill")
                    .foregroundColor(.white)
                    .font(.body.bold())
                    .frame(width: nil)
            }
            .padding()
            
            ScrollView {
                ForEach(0..<userViewModel.usersForLeaderBoard.count, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .frame(width: nil, height: 70)
                            .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        HStack(spacing: 15) {
                            Text("\(index+1)")
                            
                            AsyncImage(url: URL(string: userViewModel.usersForLeaderBoard[index].avatarUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color(red: 162/255, green: 209/255, blue: 72/255)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            
                            Text(userViewModel.usersForLeaderBoard[index].name)
                                .font(.title2.bold())
                            
                            Spacer()
                            
                            Text("\(userViewModel.usersForLeaderBoard[index].winTime) Time" + (userViewModel.usersForLeaderBoard[index].winTime > 1 ? "s" : ""))
                                .font(.title3.bold())
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            userViewModel.fetchUserForLeaderBoard()
        }
    }
}
