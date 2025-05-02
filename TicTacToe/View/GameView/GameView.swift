//
//  GameView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameViewModel
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            PlayerSelectionView()
            BoardView()
            if game.gameOver {
                GameOverView()
            }
        Spacer()
        }
            .navigationTitle("Tic Tac Toe")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("End Game"){
                        dismiss()
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .end, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            .onAppear {
                game.startGame(type: game.gameType, playerOneName: game.playerOne.name, playerTwoName: game.playerTwo.name)
                if game.gameType == .peer {
                    connectionManager.setup(game: game)
                }
            }
            .inNavigationStack()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel())
            .environmentObject(MPConnectionManager(yourName: "Sample"))
    }
}
