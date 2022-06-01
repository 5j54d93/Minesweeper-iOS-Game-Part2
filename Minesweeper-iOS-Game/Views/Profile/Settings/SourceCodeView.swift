//
//  SourceCodeView.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/1.
//

import SwiftUI

struct SourceCodeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var sourceCodeUrl = "https://github.com/5j54d93"
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Text("Minesweeper v1.0.0")
                
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
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            BrowserView(url: $sourceCodeUrl)
        }
        .navigationBarHidden(true)
        .background(Color(red: 185/255, green: 221/255, blue: 118/255))
    }
}
