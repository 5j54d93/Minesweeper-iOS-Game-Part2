//
//  StorageViewModel.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/29.
//

import SwiftUI
import FirebaseStorage

class StorageViewModel : ObservableObject {
    func uploadPhoto(id: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileReference = Storage.storage().reference().child(id + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success(_):
                    fileReference.downloadURL(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deletePhoto(id: String) {
        let fileReference = Storage.storage().reference().child(id + ".jpg")
        fileReference.delete { error in
            guard error == nil else { return }
        }
    }
}
