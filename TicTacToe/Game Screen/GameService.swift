//
//  GameService.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

@MainActor
class GameService: ObservableObject {
    @Published var playerOne = Player(gamePiece: .x, name: "Player 1")
    @Published var playerTwo = Player(gamePiece: .o, name: "Player 2")
    @Published var movesTaken = [Int]()
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset
    @Published var possibleMoves = Move.all
    
    var gameType = GameType.single
    
    var currentPlayer: Player {
        if playerOne.isCurrent {
            return playerOne
        } else {
            return playerTwo
        }
    }
    var gameStarted: Bool {
        playerOne.isCurrent || playerTwo.isCurrent
    }
    var boardDisabled: Bool {
        gameOver || !gameStarted
    }
    
    func setupGame(gameType: GameType, playerOneName: String, playerTwoName: String) {
        playerOne.name = playerOneName
        
        switch gameType {
        case .single:
            self.gameType = .single
            playerTwo.name = playerTwoName
        case .bot:
            self.gameType = .bot
        case .peer:
            self.gameType = .peer
        case .undetermined:
            break
        }
    }
    
    func reset() {
        playerOne.isCurrent = false
        playerTwo.isCurrent = false
        movesTaken.removeAll()
        playerOne.moves.removeAll()
        playerTwo.moves.removeAll()
        gameOver = false
        gameBoard = GameSquare.reset
        possibleMoves = Move.all
        
    }
    
    func updatesMoves(index: Int) {
        if playerOne.isCurrent {
            playerOne.moves.append(index + 1)
            gameBoard[index].player = playerOne
        } else {
            playerTwo.moves.append(index + 1)
            gameBoard[index].player = playerTwo
        }
    }
    
    func checkIfWinner() {
        if playerOne.isWinner || playerTwo.isWinner {
            gameOver = true
        }
    }
    
    func toggleCurrent() {
        playerOne.isCurrent.toggle()
        playerTwo.isCurrent.toggle()
    }
    
    func makeMove(at index: Int) {
        if gameBoard[index].player == nil {
            withAnimation {
                updatesMoves(index: index)
            }
            checkIfWinner()
            if !gameOver {
                if let matchingIndex = possibleMoves.firstIndex(where: {$0 ==  (index + 1)}) {
                    possibleMoves.remove(at: matchingIndex)
                }
                toggleCurrent()
            }
            
            if possibleMoves.isEmpty {
                gameOver = true
                return
            }
        }
    }
    
}
