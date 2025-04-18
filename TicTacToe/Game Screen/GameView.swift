//
//  GameView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if [game.playerOne.isCurrent, game.playerTwo.isCurrent].allSatisfy{ $0 == false } {
                Text("Select a player to start")
            }
            HStack{
                Button(game.playerOne.name) {
                    game.playerOne.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.playerOne.isCurrent))

                Button(game.playerTwo.name) {
                    game.playerTwo.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.playerTwo.isCurrent))
            }
            .disabled(game.gameStarted)
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
            .disabled(game.boardDisabled)
            VStack {
                if game.gameOver {
                    Text("Game Over")
                    if game.possibleMoves.isEmpty {
                        Text("Nobody wins")
                    } else {
                        Text("\(game.currentPlayer.name) wins!")
                    }
                    Button("New Game"){
                        game.reset()
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
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Tic Tac Toe")
        .onAppear {
            game.reset()
        }
        .inNavigationStack()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameService())
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
