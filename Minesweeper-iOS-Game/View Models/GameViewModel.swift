//
//  GameViewModel.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class GameViewModel : ObservableObject {
    @Published var game = Game(id: nil, playersId: [])
    @Published var players : [User] = []
    @Published var isInRoom = false
    
    func createAGame() {
        let db = Firestore.firestore()
        var id = String(Int.random(in: 1...99999))
        var existRoom : [String] = []
        
        db.collection("games").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let games = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Game.self)
            }
            games.forEach { game in
                existRoom.append(game.id!)
            }
        }
        
        while (existRoom.contains(id)) {
            id = String(Int.random(in: 1...99999))
        }
        
        game.id = id
        game.playersId = []
        game.playersId.append(Auth.auth().currentUser!.uid)
        
        do {
            try db.collection("games").document(id).setData(from: game)
            isInRoom = true
        } catch {
            print(error)
            isInRoom = false
        }
    }
    
    func listenToUserDataChange(id: String) {
        let db = Firestore.firestore()
        db.collection("games").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard (try? snapshot.data(as: Game.self)) != nil else { return }
            guard let game = try? snapshot.data(as: Game.self) else { return }
            self.game = game
            self.searchPlayer()
        }
    }
    
    func exitRoom(id: String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("games").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
            if game.playersId.count == 1 {
                documentReference.delete()
            } else {
                var playersId : [String] = []
                game.playersId.forEach { playerId in
                    if playerId != Auth.auth().currentUser!.uid {
                        playersId.append(playerId)
                    }
                }
                game.playersId = playersId
                do {
                    try documentReference.setData(from: game)
                } catch {
                    print(error)
                }
            }
        }
        isInRoom = false
    }
    
    func joinRoom(id: String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("games").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
            game.playersId.append(Auth.auth().currentUser!.uid)
            self.game = game
            do {
                try documentReference.setData(from: game)
            } catch {
                print(error)
            }
            self.isInRoom = true
        }
    }
    
    func searchPlayer() {
        var players : [User] = []
        let db = Firestore.firestore()
        game.playersId.forEach { playerId in
            db.collection("users").document(playerId).getDocument { document, error in
                guard let document = document, document.exists, let user = try? document.data(as: User.self) else { return }
                players.append(user)
                self.players = players
            }
        }
    }
    
    func gameStart() {
        let db = Firestore.firestore()
        let documentReference = db.collection("games").document(game.id!)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
            game.isGameStart = true
            game.isGameEnd = false
            game.grids = Array(repeating: Grid(gridType: .unTap), count: 49)
            game.turn = 0
            game.loserId = ""
            game.bombPosition = []
            for _ in 0..<7 {
                var randomNum = Int.random(in: 0..<49)
                while (game.bombPosition.contains(randomNum)) {
                    randomNum = Int.random(in: 0..<49)
                }
                game.bombPosition.append(randomNum)
            }
            self.game = game
            do {
                try documentReference.setData(from: game)
            } catch {
                print(error)
            }
        }
    }
    
    func tapGrid(index: Int) {
        let db = Firestore.firestore()
        let documentReference = db.collection("games").document(game.id!)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
            if game.bombPosition.contains(index) {
                game.grids[index].gridType = .bomb
                game.isGameEnd = true
                game.loserId = Auth.auth().currentUser!.uid
            } else {
                if index == 0 {
                    for idx in [1, 7, 8] {
                        if game.bombPosition.contains(idx) {
                            game.grids[0].num += 1
                        }
                    }
                    if game.grids[0].num > 0 {
                        game.grids[0].gridType = .number
                    } else {
                        game.grids[0].gridType = .blank
                    }
                } else if (1...5).contains(index) {
                    for idx in [index-1, index+1, index+6, index+7, index+8] {
                        if game.bombPosition.contains(idx) {
                            game.grids[index].num += 1
                        }
                    }
                    if game.grids[index].num > 0 {
                        game.grids[index].gridType = .number
                    } else {
                        game.grids[index].gridType = .blank
                    }
                } else if index == 6 {
                    for idx in [5, 12, 13] {
                        if game.bombPosition.contains(idx) {
                            game.grids[6].num += 1
                        }
                    }
                    if game.grids[6].num > 0 {
                        game.grids[6].gridType = .number
                    } else {
                        game.grids[6].gridType = .blank
                    }
                } else if stride(from: 7, to: 42, by: 7).contains(index) {
                    for idx in [index-7, index-6, index+1, index+7, index+8] {
                        if game.bombPosition.contains(idx) {
                            game.grids[index].num += 1
                        }
                    }
                    if game.grids[index].num > 0 {
                        game.grids[index].gridType = .number
                    } else {
                        game.grids[index].gridType = .blank
                    }
                } else if [(8...12), (15...19), (22...26), (29...33), (36...40)].joined().contains(index) {
                    for idx in [index-8, index-7, index-6, index-1, index+1, index+6, index+7, index+8] {
                        if game.bombPosition.contains(idx) {
                            game.grids[index].num += 1
                        }
                    }
                    if game.grids[index].num > 0 {
                        game.grids[index].gridType = .number
                    } else {
                        game.grids[index].gridType = .blank
                    }
                } else if stride(from: 13, to: 48, by: 7).contains(index) {
                    for idx in [index-8, index-7, index-1, index+6, index+7] {
                        if game.bombPosition.contains(idx) {
                            game.grids[index].num += 1
                        }
                    }
                    if game.grids[index].num > 0 {
                        game.grids[index].gridType = .number
                    } else {
                        game.grids[index].gridType = .blank
                    }
                } else if index == 42 {
                    for idx in [35, 36, 43] {
                        if game.bombPosition.contains(idx) {
                            game.grids[42].num += 1
                        }
                    }
                    if game.grids[42].num > 0 {
                        game.grids[42].gridType = .number
                    } else {
                        game.grids[42].gridType = .blank
                    }
                } else if (43...47).contains(index) {
                    for idx in [index-8, index-7, index-6, index-1, index+1] {
                        if game.bombPosition.contains(idx) {
                            game.grids[index].num += 1
                        }
                    }
                    if game.grids[index].num > 0 {
                        game.grids[index].gridType = .number
                    } else {
                        game.grids[index].gridType = .blank
                    }
                } else if index == 48 {
                    for idx in [40, 41, 47] {
                        if game.bombPosition.contains(idx) {
                            game.grids[48].num += 1
                        }
                    }
                    if game.grids[48].num > 0 {
                        game.grids[48].gridType = .number
                    } else {
                        game.grids[48].gridType = .blank
                    }
                }
            }
            if game.turn + 1 < game.playersId.count {
                game.turn += 1
            } else {
                game.turn = 0
            }
            self.game = game
            do {
                try documentReference.setData(from: game)
            } catch {
                print(error)
            }
        }
    }
    
    func endGame() {
        let db = Firestore.firestore()
        let documentReference = db.collection("games").document(game.id!)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
            game.isGameStart = false
            self.game = game
            do {
                try documentReference.setData(from: game)
            } catch {
                print(error)
            }
        }
    }
}
