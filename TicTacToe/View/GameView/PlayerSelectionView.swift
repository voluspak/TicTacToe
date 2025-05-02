//
//  PlayerSelectionView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import SwiftUI

struct PlayerSelectionView: View {
    @EnvironmentObject var game: GameViewModel
    @EnvironmentObject var connectionManager: MPConnectionManager
    var body: some View {
        if !game.playerOne.isCurrent && !game.playerTwo.isCurrent {
            Text("Select a Player to start")
        }
        HStack {
            PlayerButton(name: game.playerOne.name, isCurrent: game.playerOne.isCurrent) {
                game.playerOne.isCurrent = true
                if game.gameType == .peer {
                    connectionManager.sendStart(name: game.playerOne.name)
                }
            }
            
            PlayerButton(name: game.playerTwo.name, isCurrent: game.playerTwo.isCurrent) {
                game.playerTwo.isCurrent = true
                if game.gameType == .bot {
                    Task { await game.makeBotMove() }
                }
                
                game.playerTwo.isCurrent = true
                
                if game.gameType == .peer {
                    connectionManager.sendStart(name: game.playerTwo.name)
                }

            }
            
        }
        .disabled(game.playerOne.isCurrent || game.playerTwo.isCurrent)
    }
}

struct PlayerButton: View {
    let name: String
    let isCurrent: Bool
    let action: () -> Void
    
    var body: some View {
        Button(name, action: action)
            .buttonStyle(PlayerButtonStyle(isCurrent: isCurrent))
    }
}

struct PlayerButtonStyle: ButtonStyle {
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(isCurrent ? Color.green : Color.gray))
            .foregroundColor(Color.white)
        
    }
}

extension MPConnectionManager {
    func sendStart(name: String) {
        let move = MPGameMove(action: .start, playerName: name, index: nil)
        send(gameMove: move)
    }
}

#Preview {
    PlayerSelectionView()
        .environmentObject(GameViewModel())
        .environmentObject(MPConnectionManager(yourName: "Ejemplo"))
}
