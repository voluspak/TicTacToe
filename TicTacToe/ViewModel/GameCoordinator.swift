//
//  GameCoordinator.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import Foundation

struct GameCoordinator {
    var remainingMoves: [Int] = Move.all
    
    mutating func reset(playerOne: inout Player, playerTwo: inout Player, board: inout [GameSquare]) {
        playerOne.moves.removeAll()
        playerOne.isCurrent = false
        
        playerTwo.moves.removeAll()
        playerTwo.isCurrent = false
        
        board = GameSquare.reset
        remainingMoves = Move.all
        
    }
    
    mutating func makeMove(index: Int, playerOne: inout Player, playerTwo: inout Player, board: inout [GameSquare]) {
        if playerOne.isCurrent {
            playerOne.moves.append(index + 1)
            board[index].player = playerOne
        } else {
            playerTwo.moves.append(index + 1)
            board[index].player = playerTwo
        }
        remainingMoves.removeAll { $0 == index + 1 }
    }
    
    func checkWinner(playerOne: Player, playerTwo: Player) -> Bool {
        return playerOne.isWinner || playerTwo.isWinner || remainingMoves.isEmpty
    }
}
