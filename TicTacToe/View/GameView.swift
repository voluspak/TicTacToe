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
            if [game.playerOne.isCurrent, game.playerTwo.isCurrent].allSatisfy{ $0 == false } {
                Text("Select a player to start")
            }
            HStack{
                Button(game.playerOne.name) {
                    game.playerOne.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.playerOne.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.playerOne.isCurrent))

                Button(game.playerTwo.name) {
                    game.playerTwo.isCurrent = true
                    if game.gameType == .bot {
                        Task{
                            await game.makeBotMove()
                        }
                    }
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.playerTwo.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.playerTwo.isCurrent))
            }
            .disabled(game.playerOne.isCurrent || game.playerTwo.isCurrent)
            VStack{
                HStack{
                    ForEach(0...2, id: \.self) { index in
                        SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(3...5, id: \.self) { index in
                        SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(6...8, id: \.self) { index in
                        SquareView(index: index)
                    }
                }

            }
            .overlay{
                if game.isThinking {
                    VStack{
                        Text("Thinking...")
                            .foregroundColor(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }
            }
            .disabled(disableBoard())
            VStack {
                if game.gameOver {
                    Text("Game Over")
                    if game.coordinator.remainingMoves.isEmpty {
                        Text("Nobody wins")
                    } else {
                        Text("\(game.currentPlayer.name) wins!")
                    }
                    Button("New Game"){
                        game.coordinator.reset(playerOne: &game.playerOne, playerTwo: &game.playerTwo, board: &game.board)
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .font(.largeTitle)
            Spacer()
        }
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
        .navigationTitle("Tic Tac Toe")
        .onAppear {
            game.coordinator.reset(playerOne: &game.playerOne, playerTwo: &game.playerTwo, board: &game.board)
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        .inNavigationStack()
    }
    
    private func disableBoard() -> Bool {
        game.gameOver || game.isThinking || (
            game.gameType == .peer &&
            connectionManager.myPeerId.displayName != (game.playerOne.isCurrent ? game.playerOne.name : game.playerTwo.name)
        )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel())
            .environmentObject(MPConnectionManager(yourName: "Sample"))
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
