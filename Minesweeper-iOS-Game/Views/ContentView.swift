//
//  ContentView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var storageViewModel = StorageViewModel()
    
    var body: some View {
        if authViewModel.isSignedIn {
            TabView {
                ZStack {
                    Color(red: 190/255, green: 225/255, blue: 125/255)
                        .ignoresSafeArea()
                    
                    JoinGameView(authViewModel: authViewModel, userViewModel: userViewModel)
                }
                .tabItem {
                    Image(systemName: "gamecontroller")
                        .renderingMode(.template)
                }
                
                ZStack {
                    Color(red: 190/255, green: 225/255, blue: 125/255)
                        .ignoresSafeArea()
                    
                    LeaderBoardView(userViewModel: userViewModel)
                }
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                        .renderingMode(.template)
                }
                
                ZStack {
                    Color(red: 190/255, green: 225/255, blue: 125/255)
                        .ignoresSafeArea()
                    
                    ProfileView(authViewModel: authViewModel, userViewModel: userViewModel, storageViewModel: storageViewModel)
                }
                .tabItem {
                    Image(systemName: "person.crop.circle")
                        .renderingMode(.template)
                }
            }
            .accentColor(Color(red: 74/255, green: 117/255, blue: 44/255))
            .onAppear {
                if userViewModel.user.name == "Loading..." {
                    userViewModel.listenToUserDataChange(id: authViewModel.getId())
                }
            }
        } else {
            LogInView(authViewModel: authViewModel, userViewModel: userViewModel)
        }
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
