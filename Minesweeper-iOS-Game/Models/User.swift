//
//  User.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/28.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var avatarUrl: String
    var zodiacSign: String
    var age: Int
    var money: Int
    var winTime: Int
    var loseTime: Int
    let joinedDate: Date
}
