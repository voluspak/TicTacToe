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
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset
    @Published var possibleMoves = Move.all
    @Published var isThinking = false
    
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
        gameOver || !gameStarted || isThinking
    }
    
    func setupGame(gameType: GameType, playerOneName: String, playerTwoName: String) {
        playerOne.name = playerOneName
        
        switch gameType {
        case .single:
            self.gameType = .single
            playerTwo.name = playerTwoName
        case .bot:
            self.gameType = .bot
            playerTwo.name = UIDevice.current.name
        case .peer:
            self.gameType = .peer
        case .undetermined:
            break
        }
    }
    
    func reset() {
        playerOne.isCurrent = false
        playerTwo.isCurrent = false
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
                if gameType == .bot && currentPlayer.name == playerTwo.name {
                    Task {
                        await deviceMove()
                    }
                }
            }
            
            if possibleMoves.isEmpty {
                gameOver = true
                return
            }
        }
    }
    
    func deviceMove() async {
        isThinking.toggle()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let move = possibleMoves.randomElement() {
            if let matchingIndex = Move.all.firstIndex(where: {$0 == move}) {
                makeMove(at: matchingIndex)
            }
        }
        isThinking.toggle()
    }
    
}

extension GameSquare {
    var image: Image {
        if let player = player {
            return player.gamePiece.image
        } else {
            return Image("none")
        }
    }
}
