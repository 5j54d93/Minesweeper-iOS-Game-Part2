//
//  SignUpWithEmailView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/30.
//

import SwiftUI
import FirebaseAuth

struct SignUpWithEmailView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    
    @Binding var signUpWithEmail : Bool
    @Binding var email : String
    @Binding var password : String
    
    @State private var name = ""
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    var body: some View {
        Text("Sign up with Email")
            .foregroundColor(Color(red: 74/255, green: 117/255, blue: 44/255))
            .font(.title.bold())
            .padding(.bottom)
        
        TextField("Name", text: $name, prompt: Text("Name"))
            .font(.title2.bold())
            .padding()
            .foregroundColor(.black)
            .background(Color(red: 162/255, green: 209/255, blue: 72/255))
            .cornerRadius(5)
            .disableAutocorrection(true)
        
        TextField("Email", text: $email, prompt: Text("Email"))
            .font(.title2.bold())
            .padding()
            .foregroundColor(.black)
            .background(Color(red: 162/255, green: 209/255, blue: 72/255))
            .cornerRadius(5)
            .disableAutocorrection(true)
            .autocapitalization(.none)
        
        SecureField("Password", text: $password, prompt: Text("Password"))
            .font(.title2.bold())
            .padding()
            .foregroundColor(.black)
            .background(Color(red: 162/255, green: 209/255, blue: 72/255))
            .cornerRadius(5)
        
        Button {
            authViewModel.signUp(email: email, password: password) { result in
                switch result {
                case .failure(let error):
                    switch error.code {
                    case AuthErrorCode.networkError.rawValue:
                        alertTitle = "Can't connect the network"
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        alertTitle = "You've signed up for this email. Try to log in!"
                    default:
                        break
                    }
                    showAlert = true
                case .success(let id):
                    authViewModel.updateProfile(newName: name, newAvatarUrl: Auth.auth().currentUser?.photoURL)
                    userViewModel.addUser(user: User(id: id, name: name, email: email, avatarUrl: "", zodiacSign: "Not set", age: 18, money: 2000, winTime: 0, loseTime: 0, joinedDate: Date.now))
                    userViewModel.listenToUserDataChange(id: id)
                    signUpWithEmail = false
                }
            }
        } label: {
            Text("Sign Up")
                .padding()
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(
                    !email.isEmpty && !password.isEmpty
                    ? Color(red: 74/255, green: 117/255, blue: 44/255)
                    : Color(red: 162/255, green: 209/255, blue: 72/255)
                )
                .cornerRadius(5)
        }
        .disabled(email.isEmpty || password.isEmpty || name.isEmpty)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                showAlert = false
            }
        }
    }
}

