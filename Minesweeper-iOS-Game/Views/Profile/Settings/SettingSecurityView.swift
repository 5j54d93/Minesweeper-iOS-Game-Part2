//
//  SettingSecurityView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/1.
//

import SwiftUI

struct SettingSecurityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel : AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Text("Security")
                
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
            
            Text("Login Security")
                .font(.title3.bold())
                .padding(.vertical)
            
            NavigationLink {
                ChangePasswordView(authViewModel: authViewModel)
            } label: {
                HStack {
                    Label("Password", systemImage: "key")
                    Spacer()
                    Text(Image(systemName: "chevron.forward"))
                }
            }
            .font(.title3)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .background(Color(red: 185/255, green: 221/255, blue: 118/255))
    }
}
