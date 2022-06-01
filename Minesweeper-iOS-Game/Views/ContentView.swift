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
                    
                    
                }
                .tabItem {
                    Image(systemName: "gamecontroller")
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
