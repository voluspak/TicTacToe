//
//  GameModel.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

enum GameType {
    case single, bot, peer, undetermined
    
    var description: String {
        switch self  {
        case .single:
            return "Share your iPhone/iPad and play against a friend"
        case .bot:
            return "Play against this iPhone/iPad"
        case .peer:
            return "Invite someone near you who has this app and running to play"
        case .undetermined:
            return ""
        }
    }
}

enum GamePiece: String {
    case x,o
}

struct Player {
    let gamePiece: GamePiece
    var name: String
    var moves: [Int] = []
    var isCurrent: Bool = false
    var isWinner: Bool {
        Move.winningMoves.contains { winSet in
            winSet.allSatisfy(moves.contains)
        }
    }
}

enum Move {
    static var all = [1,2,3,4,5,6,7,8,9]
    static var winningMoves = [
        [1,2,3],
        [4,5,6],
        [7,8,9],
        [1,4,7],
        [2,5,8],
        [3,6,9],
        [3,5,7],
        [1,5,9]
    ]
}

struct GameSquare {
    var id: Int
    var player: Player?
    
    
    static var reset: [GameSquare] {
        var squares = [GameSquare]()
        for index in 1...9 {
            squares.append(GameSquare(id: index))
        }
        return squares
    }
}

