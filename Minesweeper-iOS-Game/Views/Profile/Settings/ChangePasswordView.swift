//
//  ChangePasswordView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/1.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel : AuthViewModel
    
    @State private var newPassword = ""
    @State private var newPasswordAgain = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Text("Change password")
                
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
            
            Text("If you can't change your password successfully, re-login and try again.")
                .padding(.vertical)
            
            VStack(spacing: 15) {
                SecureField("New password", text: $newPassword, prompt: Text("New password"))
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(red: 162/255, green: 209/255, blue: 72/255))
                    .cornerRadius(5)
                
                SecureField("New password, again", text: $newPasswordAgain, prompt: Text("New password, again"))
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(red: 162/255, green: 209/255, blue: 72/255))
                    .cornerRadius(5)
                
                Button {
                    if newPassword == newPasswordAgain {
                        authViewModel.changePassword(password: newPassword)
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("Change password")
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            !newPassword.isEmpty && !newPasswordAgain.isEmpty
                            ? Color(red: 74/255, green: 117/255, blue: 44/255)
                            : Color(red: 162/255, green: 209/255, blue: 72/255)
                        )
                        .cornerRadius(5)
                }
                .disabled(newPassword.isEmpty && newPasswordAgain.isEmpty)
            }
            .font(.title2.bold())
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .background(Color(red: 185/255, green: 221/255, blue: 118/255))
        .alert("You've typed two different password", isPresented: $showAlert) {
            Button("OK") {
                showAlert = false
            }
        }
    }
}
