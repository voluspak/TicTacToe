//
//  BoardView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var game: GameViewModel
    @EnvironmentObject var connectionManager: MPConnectionManager
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<3) { row in
                HStack(spacing: 4) {
                    ForEach(0..<3) { col in
                        let idx = row * 3 + col
                        SquareView(index: idx)
                    }
                }
            }
        }
        .overlay {
            if game.isThinking {
                ThinkingOverlay()
            }
        }
        .disabled(game.gameOver ||
                  (!game.playerOne.isCurrent && !game.playerTwo.isCurrent) ||
                  (game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
        )
    }
        
}

#Preview {
    BoardView()
        .environmentObject(GameViewModel())
        .environmentObject(MPConnectionManager(yourName: "Ejemplo"))
}
