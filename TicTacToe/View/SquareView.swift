//
//  SquareView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game: GameViewModel
    @EnvironmentObject var connectionManager: MPConnectionManager
    let index: Int
    var body: some View {
        Button{
            if !game.isThinking {
                game.makeMove(at: index)
            }
            if game.gameType == .peer {
                let gameMove = MPGameMove(action: .move, playerName: connectionManager.myPeerId.displayName, index: index)
                connectionManager.send(gameMove: gameMove)
            }
        } label: {
            game.board[index].image
                .resizable()
                .frame(width: 100, height: 100)
        }
        .disabled(game.board[index].player != nil)
        .foregroundColor(.primary)
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView(index: 1)
            .environmentObject(GameViewModel())
            .environmentObject(MPConnectionManager(yourName: "Sample"))
    }
}
