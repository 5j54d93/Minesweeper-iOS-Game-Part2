//
//  EditProfileView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/28.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct EditProfileView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    @ObservedObject var storageViewModel : StorageViewModel
    
    @Binding var isEditProfile : Bool
    
    @State private var name = "Not set"
    @State private var email = "Not set"
    @State private var zodiacSign = "Not set"
    @State private var age: Double = 18
    
    let zodiac = ["Not set", "Aquarius", "Pisces", "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Text("Edit Profile")
                        .font(.title2.bold())
                    
                    HStack {
                        Button {
                            isEditProfile = false
                        } label: {
                            Text("Cancel")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button {
                            userViewModel.updateUser(name: name, email: email, zodiacSign: zodiacSign, age: Int(age), avatarUrl: nil)
                            authViewModel.updateProfile(newName: name, newAvatarUrl: nil)
                            authViewModel.updateEmail(email: email)
                            isEditProfile = false
                        } label: {
                            Text("Done")
                                .font(.title3.bold())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                Divider()
                
                AvatarEditView(authViewModel: authViewModel, userViewModel: userViewModel, storageViewModel: storageViewModel, geometry: geometry)
                
                Divider()
                    .padding(.bottom, 0)
                
                HStack {
                    VStack {
                        HStack {
                            Text("Name")
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .hidden()
                        
                        HStack {
                            Text("Email")
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .hidden()
                        
                        HStack {
                            Text("Zodiac Sign")
                            Spacer()
                        }
                        .padding(.vertical, 10)
                    }
                    .font(.title3)
                    .padding(.leading)
                    .frame(width: geometry.size.width/3)
                    
                    VStack(alignment: .leading) {
                        TextField("Name", text: $name, prompt: Text("Name"))
                            .disableAutocorrection(true)
                            .padding(.vertical, 10)
                        
                        Divider()
                        
                        TextField("Email", text: $email, prompt: Text("Email"))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.vertical, 10)
                        
                        Divider()
                        
                        Menu {
                            Picker(selection: $zodiacSign) {
                                ForEach(zodiac, id: \.self) { item in
                                    Text(item)
                                }
                            } label: {}
                        } label: {
                            Text(zodiacSign)
                        }
                        .padding(.vertical, 10)
                    }
                    .font(.title3)
                    .foregroundColor(.black)
                    .frame(width: geometry.size.width/3*2)
                }
                
                Divider()
                    .padding(.top, 0)
                
                HStack {
                    HStack {
                        Text("Age")
                        Spacer()
                    }
                    .padding(.leading)
                    .frame(width: geometry.size.width/3)
                    
                    HStack {
                        Text("\(Int(age)) years old")
                        Spacer()
                    }
                    .frame(width: geometry.size.width/3*2)
                }
                .padding(.vertical, 10)
                .font(.title3)
                
                Slider(value: $age, in: 1...100, step: 1) {
                    Text("age")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("100")
                }
                .padding(.horizontal)
                
                Divider()
                
                Spacer()
            }
            .background(Color(red: 190/255, green: 225/255, blue: 125/255))
        }
        .onAppear {
            name = userViewModel.user.name
            email = userViewModel.user.email
            zodiacSign = userViewModel.user.zodiacSign
            age = Double(userViewModel.user.age)
        }
    }
}

struct AvatarEditView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    @ObservedObject var storageViewModel : StorageViewModel
    
    @State private var isChangeAvatar = false
    
    let geometry : GeometryProxy
    
    var body: some View {
        Button {
            isChangeAvatar = true
        } label: {
            VStack {
                AsyncImage(url: URL(string: userViewModel.user.avatarUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color(red: 162/255, green: 209/255, blue: 72/255)
                }
                .frame(width: geometry.size.width/3, height: geometry.size.width/3)
                .clipShape(Circle())
                .padding(.top)
                
                Text("Change avatar")
                    .bold()
                    .padding(.vertical, 10)
            }
        }
        .fullScreenCover(isPresented: $isChangeAvatar) {
            ChangeAvatarView(authViewModel: authViewModel, userViewModel: userViewModel, storageViewModel: storageViewModel, isChangeAvatar: $isChangeAvatar)
        }
    }
}
