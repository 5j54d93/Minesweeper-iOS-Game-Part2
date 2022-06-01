//
//  ChangeAvatarView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/28.
//

import SwiftUI

struct ChangeAvatarView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @ObservedObject var userViewModel : UserViewModel
    @ObservedObject var storageViewModel : StorageViewModel
    
    @AppStorage("bodyImgName") var bodyImgName = "body0"
    @AppStorage("headImgName") var headImgName = "head0"
    @AppStorage("faceImgName") var faceImgName = "face0"
    @AppStorage("backgroundColor") var backgroundColor = Color(red: 162/255, green: 209/255, blue: 72/255)
    
    @Binding var isChangeAvatar : Bool
    
    @State private var uiImage: UIImage?
    @State private var selection = "body"
    @State private var tempBodyImgName = "body0"
    @State private var tempHeadImgName = "head0"
    @State private var tempFaceImgName = "face0"
    @State private var imgNum = 30
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Text("Change Avatar")
                        .font(.title2.bold())
                    
                    HStack {
                        Button {
                            isChangeAvatar = false
                        } label: {
                            Text("Cancel")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button {
                            bodyImgName = tempBodyImgName
                            headImgName = tempHeadImgName
                            faceImgName = tempFaceImgName
                            uiImage = AvatarView(bodyImgName: tempBodyImgName, headImgName: tempHeadImgName, faceImgName: tempFaceImgName, geometry: geometry).snapshot()
                            storageViewModel.uploadPhoto(id: userViewModel.user.id!, image: uiImage!) { result in
                                switch result {
                                case .success(let url):
                                    authViewModel.updateProfile(newName: userViewModel.user.name, newAvatarUrl: url)
                                    userViewModel.updateUser(name: userViewModel.user.name, email: userViewModel.user.email, zodiacSign: userViewModel.user.zodiacSign, age: userViewModel.user.age, avatarUrl: url.absoluteString)
                                    isChangeAvatar = false
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Done")
                                .font(.title3.bold())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                Divider()
                
                AvatarView(bodyImgName: tempBodyImgName, headImgName: tempHeadImgName, faceImgName: tempFaceImgName, geometry: geometry)
                    .padding(.vertical)
                    .onAppear {
                        tempBodyImgName = bodyImgName
                        tempHeadImgName = headImgName
                        tempFaceImgName = faceImgName
                    }
                
                HStack {
                    Button {
                        tempBodyImgName = "body" + String(describing: (0..<30).randomElement()!)
                        tempHeadImgName = "head" + String(describing: (0..<46).randomElement()!)
                        tempFaceImgName = "face" + String(describing: (0..<30).randomElement()!)
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color(red: 255/255, green: 191/255, blue: 0/255))
                                .cornerRadius(5)
                            
                            Text(Image(systemName: "die.face.5.fill"))
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        selection = "body"
                        imgNum = 30
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: nil, height: 45)
                                .foregroundColor(selection == "body" ? Color(red: 74/255, green: 117/255, blue: 44/255) : Color(red: 162/255, green: 209/255, blue: 72/255))
                                .cornerRadius(5)
                            
                            Text("Body")
                                .bold()
                                .foregroundColor(selection == "body" ? .white : .black)
                        }
                    }
                    
                    Button {
                        selection = "head"
                        imgNum = 46
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: nil, height: 45)
                                .foregroundColor(selection == "head" ? Color(red: 74/255, green: 117/255, blue: 44/255) : Color(red: 162/255, green: 209/255, blue: 72/255))
                                .cornerRadius(5)
                            
                            Text("Head")
                                .bold()
                                .foregroundColor(selection == "head" ? .white : .black)
                        }
                    }
                    
                    Button {
                        selection = "face"
                        imgNum = 30
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: nil, height: 45)
                                .foregroundColor(selection == "face" ? Color(red: 74/255, green: 117/255, blue: 44/255) : Color(red: 162/255, green: 209/255, blue: 72/255))
                                .cornerRadius(5)
                            
                            Text("Face")
                                .bold()
                                .foregroundColor(selection == "face" ? .white : .black)
                        }
                    }
                    
                    backgroundColor
                        .frame(width: 45, height: 45, alignment: .center)
                        .cornerRadius(5)
                        .overlay(ColorPicker("", selection: $backgroundColor).labelsHidden())
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 8), count: 4), spacing: 8) {
                        ForEach(0..<imgNum, id: \.self) { index in
                            GeometryReader { geo in
                                Rectangle()
                                    .frame(width: nil, height: geo.size.width)
                                    .foregroundColor(Color(red: 162/255, green: 209/255, blue: 72/255))
                                    .cornerRadius(8)
                                    .overlay {
                                        Image("\(selection)\(index)")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geo.size.width*0.85, height: geo.size.width*0.85)
                                    }
                                    .onTapGesture {
                                        switch selection {
                                        case "body":
                                            tempBodyImgName = "body\(index)"
                                        case "head":
                                            tempHeadImgName = "head\(index)"
                                        case "face":
                                            tempFaceImgName = "face\(index)"
                                        default:
                                            break;
                                        }
                                    }
                            }
                            .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(red: 190/255, green: 225/255, blue: 125/255))
        }
    }
}

struct AvatarView: View {
    
    @AppStorage("backgroundColor") var backgroundColor = Color(red: 162/255, green: 209/255, blue: 72/255)
    
    let bodyImgName : String
    let headImgName : String
    let faceImgName : String
    let geometry : GeometryProxy
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(backgroundColor)
                .frame(width: geometry.size.width*0.8, height: geometry.size.width*0.8)
            
            Image(bodyImgName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width*0.5, height: geometry.size.width*0.5)
                .offset(x: -10, y: 70)
            
            Image(headImgName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width*0.3, height: geometry.size.width*0.3)
                .offset(x: 7, y: -85)
            
            Image(faceImgName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width*0.19, height: geometry.size.width*0.19)
                .offset(x: 11, y: -68)
            
            Circle()
                .stroke(.gray, lineWidth: 1)
                .frame(width: geometry.size.width*0.8, height: geometry.size.width*0.8)
        }
    }
}
