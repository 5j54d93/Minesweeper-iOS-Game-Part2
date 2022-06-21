//
//  LogInView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/24.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    
    @State private var signUpWithEmail = false
    @State private var email = ""
    @State private var password = ""
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Minesweeper")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .background(Color(red: 74/255, green: 117/255, blue: 44/255))
            
            if signUpWithEmail {
                HStack {
                    Button {
                        signUpWithEmail = false
                    } label: {
                        Label("Back to log in", systemImage: "chevron.backward")
                    }
                    
                    Spacer()
                }
                .font(.title2.bold())
                .padding(.init(top: 10, leading: 15, bottom: 0, trailing: 0))
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                if !signUpWithEmail {
                    Text("Log in to Minesweeper")
                        .foregroundColor(Color.accentColor)
                        .font(.title.bold())
                        .padding(.bottom)
                    
                    Group {
                        TextField("Email", text: $email, prompt: Text("Email"))
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text: $password, prompt: Text("Password"))
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(red: 162/255, green: 209/255, blue: 72/255))
                            .cornerRadius(5)
                        
                        Button {
                            authViewModel.logIn(email: email, password: password) { result in
                                switch result {
                                case .failure(let error):
                                    switch error.code {
                                    case AuthErrorCode.networkError.rawValue:
                                        alertTitle = "Can't connect the network"
                                    case AuthErrorCode.invalidEmail.rawValue:
                                        alertTitle = "Email is invalid"
                                    case AuthErrorCode.userNotFound.rawValue:
                                        alertTitle = "You should sign up an account first"
                                    case AuthErrorCode.wrongPassword.rawValue:
                                        alertTitle = "Your password is wrong"
                                    default:
                                        break
                                    }
                                    showAlert = true
                                case .success(let id):
                                    userViewModel.listenToUserDataChange(id: id)
                                }
                            }
                        } label: {
                            Text("Log in")
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(
                                    !email.isEmpty && !password.isEmpty
                                    ? Color(red: 74/255, green: 117/255, blue: 44/255)
                                    : Color(red: 162/255, green: 209/255, blue: 72/255)
                                )
                                .cornerRadius(5)
                        }
                        .disabled(email.isEmpty && password.isEmpty)
                    }
                    .font(.title2.bold())
                    
                    Text("OR")
                        .foregroundColor(Color.accentColor)
                        .padding()
                    
                    Button {
                        signUpWithEmail = true
                    } label: {
                        Label("Sign up with Email", systemImage: "envelope")
                            .padding()
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 74/255, green: 117/255, blue: 44/255))
                            .cornerRadius(5)
                    }
                } else {
                    SignUpWithEmailView(authViewModel: authViewModel, userViewModel: userViewModel, signUpWithEmail: $signUpWithEmail, email: $email, password: $password)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(red: 190/255, green: 225/255, blue: 125/255))
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                showAlert = false
            }
        }
    }
}
