//
//  AuthViewModel.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/30.
//

import Foundation
import FirebaseAuth

class AuthViewModel : ObservableObject {
    
    @Published var isSignedIn = false
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.isSignedIn = user != nil
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping (Result<String, NSError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                if let error = error {
                    let error = error as NSError
                    completion(.failure(error))
                }
                return
            }
            guard let uid = authResult?.user.uid else { return }
            completion(.success(uid))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, NSError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                if let error = error {
                    let error = error as NSError
                    completion(.failure(error))
                }
                return
            }
            guard let uid = authResult?.user.uid else { return }
            completion(.success(uid))
        }
    }
    
    func getId() -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        return ""
    }
    
    func updateProfile(newName: String, newAvatarUrl: URL?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        if let newAvatarUrl = newAvatarUrl {
            changeRequest?.photoURL = newAvatarUrl
        }
        changeRequest?.commitChanges { error in
            guard error == nil else { return }
        }
    }
    
    func updateEmail(email: String) {
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            guard error == nil else {
                return
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            guard error == nil else {
                return
            }
        }
    }
    
    func changePassword(password: String) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            guard error == nil else {
                return
            }
        }
    }
}
