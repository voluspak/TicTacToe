//
//  GameCoordinator.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 30/4/25.
//

import Foundation

struct GameCoordinator {
    var remainingMoves: [Int] = Move.all
    
    mutating func reset(playerOne: inout Player, playerTwo: inout Player, board: inout [GameSquare]) {
        playerOne.moves.removeAll()
        playerOne.isCurrent = true
        
        playerTwo.moves.removeAll()
        playerTwo.isCurrent = false

        board = GameSquare.reset
        remainingMoves = Move.all    }
    
    mutating func makeMove(index: Int, playerOne: inout Player, playerTwo: inout Player, board: inout [GameSquare]) {
        var current = playerOne.isCurrent ? playerOne : playerTwo
        current.moves.append(index + 1)
        board[index].player = current
        
        remainingMoves.removeAll { $0 == index + 1 }
        playerOne.isCurrent.toggle()
        playerTwo.isCurrent.toggle()
    }
    
    func checkWinner(playerOne: Player, playerTwo: Player) -> Bool {
        return playerOne.isWinner || playerTwo.isWinner || remainingMoves.isEmpty
    }
}
