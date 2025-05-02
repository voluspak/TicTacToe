//
//  GameOverView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var game: GameViewModel
    @EnvironmentObject var connectionManager: MPConnectionManager
    
    var body: some View {
        VStack(spacing: 8) {
            Text("¡GAME OVER!")
            if game.coordinator.remainingMoves.isEmpty {
                Text("Nobody wins")
            } else {
                Text("\(game.currentPlayer.name) wins!")
            }
            Button("New Game", action: newGame)
                .buttonStyle(.borderedProminent)
        }
        .font(.largeTitle)
    }
    
    private func newGame() {
        game.startGame(type: game.gameType, playerOneName: game.playerOne.name, playerTwoName: game.playerTwo.name)
        if game.gameType == .peer {
            connectionManager.sendReset()
        }
    }
}

extension MPConnectionManager {
    func sendReset() {
        let move = MPGameMove(action: .reset, playerName: nil, index: nil)
        send(gameMove: move)
    }
}

#Preview {
    GameOverView()
        .environmentObject(GameViewModel())
        .environmentObject(MPConnectionManager(yourName: "Ejemplo"))
}
