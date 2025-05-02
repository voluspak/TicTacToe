//
//  OpponentConfigView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 2/5/25.
//

import SwiftUI

struct OpponentConfigView: View {
    @Binding var gameType: GameType
    @Binding var opponentName: String
    @Binding var selectDifficulty: BotService.Difficulty?
    @Binding var startGame: Bool
    @FocusState var focus: Bool
    
    @EnvironmentObject var connectionManager: MPConnectionManager
    
    var body: some View {
        VStack(spacing: 16) {
            switch gameType {
            case .single:
                TextField("Opponent Name", text: $opponentName)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus)
            case .bot:
                DifficultyPickerView(selection: $selectDifficulty)
            case .peer:
                MPPeersView(startGame: $startGame)
                    .environmentObject(connectionManager)
            case .undetermined:
                EmptyView()
            }
        }
        .padding()
        .frame(width: 350)
    }
}

#Preview {
    var gameType = GameType.bot
    var opponentName = "Rival"
    var selectedDifficulty: BotService.Difficulty? = .hard
    var startGame = false

    OpponentConfigView(
        gameType: .constant(gameType),
        opponentName: .constant(opponentName),
        selectDifficulty: .constant(selectedDifficulty),
        startGame: .constant(startGame)
    )
}
