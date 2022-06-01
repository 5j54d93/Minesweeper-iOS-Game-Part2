//
//  SettingView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/31.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    @ObservedObject var storageViewModel : StorageViewModel

    @State private var showDeleteAccountAlert = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ZStack {
                    Text("Settings")
                    
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
                
                NavigationLink {
                    SettingSecurityView(authViewModel: authViewModel)
                } label: {
                    HStack {
                        Label("Security", systemImage: "lock.shield")
                        Spacer()
                        Text(Image(systemName: "chevron.forward"))
                    }
                }
                .font(.title3)
                .padding(.vertical)
                
                NavigationLink {
                    AboutView()
                } label: {
                    HStack {
                        Label("About", systemImage: "info.circle")
                        Spacer()
                        Text(Image(systemName: "chevron.forward"))
                    }
                }
                .font(.title3)
                .padding(.vertical)
                
                Divider()
                
                Text("Logins")
                    .font(.title3.bold())
                    .padding(.vertical)
                
                Button("Log out") {
                    authViewModel.logOut()
                }
                .font(.title3)
                
                Button("Delete account") {
                    showDeleteAccountAlert = true
                }
                .font(.title3)
                .padding(.vertical)
                
                Divider()
            }
            .padding(.horizontal)
            .background(Color(red: 190/255, green: 225/255, blue: 125/255))
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color(red: 185/255, green: 221/255, blue: 118/255))
        .alert("Are you sure to delete your account permanently ?", isPresented: $showDeleteAccountAlert) {
            Button(role: .cancel) {
                showDeleteAccountAlert = false
            } label: {
                Text("Chanel")
            }
            Button(role: .destructive) {
                showDeleteAccountAlert = false
                storageViewModel.deletePhoto(id: userViewModel.user.id!)
                userViewModel.deleteUser()
                authViewModel.deleteAccount()
            } label: {
                Text("Yes")
            }
        }
    }
}
