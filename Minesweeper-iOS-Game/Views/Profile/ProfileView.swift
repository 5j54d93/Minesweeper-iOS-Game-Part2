//
//  ProfileView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/28.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    @ObservedObject var storageViewModel : StorageViewModel
    
    @State private var isEditProfile = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Profile")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    NavigationLink {
                        SettingView(authViewModel: authViewModel, userViewModel: userViewModel, storageViewModel: storageViewModel)
                    } label: {
                        Text(Image(systemName: "gearshape.fill"))
                            .font(.title2.bold())
                    }
                }
                .padding(.bottom).padding(.horizontal)
                .foregroundColor(.white)
                .background(Color(red: 74/255, green: 117/255, blue: 44/255))
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        AsyncImage(url: URL(string: userViewModel.user.avatarUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color(red: 162/255, green: 209/255, blue: 72/255)
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        
                        Spacer()
                        
                        VStack {
                            Text("\(userViewModel.user.winTime)")
                                .font(.title2.bold())
                            Text("Win")
                                .font(.title3)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("\(userViewModel.user.loseTime)")
                                .font(.title2.bold())
                            Text("Lose")
                                .font(.title3)
                        }
                        
                        Spacer()
                        
                        VStack {
                            userViewModel.user.winTime + userViewModel.user.loseTime == 0
                            ? Text("0")
                                .font(.title2.bold())
                            : Text("\(Double(userViewModel.user.winTime)/Double((userViewModel.user.winTime + userViewModel.user.loseTime))*100, specifier: "%.2f")")
                                .font(.title2.bold())
                            Text("Win %")
                                .font(.title3)
                        }
                    }
                    
                    Text(userViewModel.user.name)
                        .font(.title2.bold())
                    
                    Button {
                        isEditProfile = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 74/255, green: 117/255, blue: 44/255), lineWidth: 1)
                                .frame(width: nil, height: 40)
                            
                            Text("Edit profile")
                                .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
                                .bold()
                                .frame(width: nil)
                        }
                        .padding(.vertical)
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: nil, height: 55)
                            .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        HStack {
                            Label("Age", systemImage: "person.fill.viewfinder")
                                .font(.body.bold())
                            
                            Spacer()
                            
                            Text("\(userViewModel.user.age)")
                        }
                        .padding(.horizontal)
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: nil, height: 55)
                            .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        HStack {
                            Label("Zodiac Sign", systemImage: "gyroscope")
                                .font(.body.bold())
                            
                            Spacer()
                            
                            Text(userViewModel.user.zodiacSign)
                        }
                        .padding(.horizontal)
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: nil, height: 55)
                            .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        HStack {
                            Label("Money", systemImage: "dollarsign.circle")
                                .font(.body.bold())
                            
                            Spacer()
                            
                            Text("$ \(userViewModel.user.money)")
                        }
                        .padding(.horizontal)
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: nil, height: 55)
                            .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        HStack {
                            Label("Joined", systemImage: "calendar")
                                .font(.body.bold())
                            
                            Spacer()
                            
                            Text("\(userViewModel.user.joinedDate.formatted(date: .abbreviated, time: .omitted))")
                        }
                        .padding(.horizontal)
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: nil, height: 55)
                            .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        HStack {
                            Label("Email", systemImage: "envelope")
                                .font(.body.bold())
                            
                            Spacer()
                            
                            Text(userViewModel.user.email)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
            .background(Color(red: 190/255, green: 225/255, blue: 125/255))
            .fullScreenCover(isPresented: $isEditProfile) {
                EditProfileView(authViewModel: authViewModel, userViewModel: userViewModel, storageViewModel: storageViewModel, isEditProfile: $isEditProfile)
            }
        }
    }
}
