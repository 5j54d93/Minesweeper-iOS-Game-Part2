//
//  AboutView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/1.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Text("About")
                
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
                SourceCodeView()
            } label: {
                HStack {
                    Text("Open source code")
                    Spacer()
                    Text(Image(systemName: "chevron.forward"))
                }
            }
            .font(.title3)
            .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .background(Color(red: 185/255, green: 221/255, blue: 118/255))
    }
}
