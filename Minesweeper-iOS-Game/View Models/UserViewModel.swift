//
//  UserViewModel.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/28.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserViewModel : ObservableObject {
    
    @Published var user = User(id: nil, name: "Loading...", email: "Loading...", avatarUrl: "", zodiacSign: "Loading...", age: 18, money: 2000, winTime: 0, loseTime: 0, joinedDate: Date.now)
    
    func addUser(user: User) {
        let db = Firestore.firestore()
        
        do {
            try db.collection("users").document(user.id!).setData(from: user)
        } catch {
            print(error)
        }
    }
    
    func listenToUserDataChange(id: String) {
        let db = Firestore.firestore()
        db.collection("users").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard (try? snapshot.data(as: User.self)) != nil else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.user = user
        }
    }
    
    func updateUser(name: String, email: String, zodiacSign: String, age: Int, avatarUrl: String?) {
        let db = Firestore.firestore()
        let documentReference = db.collection("users").document(user.id!)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var user = try? document.data(as: User.self) else { return }
            user.name = name
            user.email = email
            user.zodiacSign = zodiacSign
            user.age = age
            if let avatarUrl = avatarUrl {
                user.avatarUrl = avatarUrl
            }
            do {
                try documentReference.setData(from: user)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteUser() {
        let db = Firestore.firestore()
        let documentReference = db.collection("users").document(user.id!)
        documentReference.delete()
    }
}
