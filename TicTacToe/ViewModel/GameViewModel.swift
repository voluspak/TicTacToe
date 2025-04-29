//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var board = GameSquare.reset
    @Published var gameOver = false
    @Published var isThinking = false
    @Published var playerOne = Player(gamePiece: .x, name: "Player 1")
    @Published var playerTwo = Player(gamePiece: .o, name: "Player 2")
    
    let botService = BotService()
    var coordinator = GameCoordinator()
    
    var gameType: GameType = .single
    var currentPlayer: Player {
        playerOne.isCurrent
        ? playerOne
        : playerTwo
    }
    
    
    func startGame(type: GameType, playerOneGame: String, playerTwoName: String) {
        self.gameType = type
        playerOne.name = playerOneGame
        playerTwo.name = playerTwoName
        resetGame()
    }
        
        func resetGame() {
            coordinator.reset(playerOne: &playerOne, playerTwo: &playerTwo, board: &board)
            gameOver = false
            isThinking = false
        }
        
        func makeMove(at index: Int) {
            guard board[index].player == nil, !gameOver else { return }
            
            withAnimation {
                coordinator.makeMove(index: index, playerOne: &playerOne, playerTwo: &playerTwo, board: &board)
            }
            
            
            gameOver = coordinator.checkWinner(playerOne: playerOne, playerTwo: playerTwo)
            
            if !gameOver {
                playerOne.isCurrent.toggle()
                playerTwo.isCurrent.toggle()
            }
            
            if !gameOver && gameType == .bot && currentPlayer.name == playerTwo.name{
                Task {
                    await makeBotMove()
                }
            }
        }
        
        var gameStarted: Bool {
            playerOne.isCurrent || playerTwo.isCurrent
        }
        
        func makeBotMove() async{
            isThinking = true
            let move = await botService.calculateMove(possibleMoves: coordinator.remainingMoves)
            isThinking = false
            if let index = Move.all.firstIndex(of: move) {
                makeMove(at: index)
            }
        }
    }
