//
//  GameService.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var board = GameSquare.reset
    @Published var gameOver = false
    @Published var isThinking = false
    @Published var playerOne: Player
    @Published var playerTwo: Player
    
    private let botService: BotService
    var coordinator: GameCoordinator
    
    var gameType: GameType
    var currentPlayer: Player {
        playerOne.isCurrent ? playerOne : playerTwo
    }

    init(botService: BotService = BotService(),
         coordinator: GameCoordinator = GameCoordinator()) {
        self.botService = botService
        self.coordinator = coordinator
        self.playerOne = Player(gamePiece: .x, name: "Player 1")
        self.playerTwo = Player(gamePiece: .o, name: "Player 2")
        self.gameType = .single
    }

    func startGame(type: GameType, playerOneName: String, playerTwoName: String) {
        self.gameType = type
        playerOne.name = playerOneName
        playerTwo.name = playerTwoName
        coordinator.reset(playerOne: &playerOne, playerTwo: &playerTwo, board: &board)
    }

    func makeMove(at index: Int) {
        guard board[index].player == nil, !gameOver else { return }
        
        coordinator.makeMove(index: index, playerOne: &playerOne, playerTwo: &playerTwo, board: &board)
        gameOver = coordinator.checkWinner(playerOne: playerOne, playerTwo: playerTwo)

        if gameType == .bot && currentPlayer.name == playerTwo.name && !gameOver {
            Task {
                await makeBotMove()
            }
        }
    }

    func makeBotMove() async {
        isThinking = true
        let move = await botService.calculateMove(possibleMoves: coordinator.remainingMoves)
        isThinking = false
        if let index = Move.all.firstIndex(of: move) {
            makeMove(at: index)
        }
    }
}


