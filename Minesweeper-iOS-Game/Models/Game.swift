//
//  Game.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/6/13.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

enum GridType: Codable { case unTap, blank, number, bomb }

struct Grid: Codable {
    var gridType: GridType
    var foregroundColor: Color {
        switch self.gridType {
        case .unTap: return Color(red: 162/255, green: 209/255, blue: 72/255)
        case .blank: return Color(red: 229/255, green: 194/255, blue: 159/255)
        case .number: return Color(red: 215/255, green: 184/255, blue: 153/255)
        case .bomb: return Color(red: 219/255, green: 50/255, blue: 54/255)
        }
    }
    var num = 0
}

struct Game: Codable, Identifiable {
    @DocumentID var id: String?
    var playersId: [String]
    var isGameStart = false
    var isGameEnd = false
    var grids = Array(repeating: Grid(gridType: .unTap), count: 49)
    var bombPosition: [Int] = []
    var turn = 0
    var loserId = ""
}
