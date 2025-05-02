//
//  GameTypePickerView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 2/5/25.
//

import SwiftUI

struct GameTypePickerView: View {
    @Binding var gameType: GameType
    
    var body: some View {
        Picker("Select Game", selection: $gameType) {
            Text("Select Game Type").tag(GameType.undetermined)
            Text("Two Sharing Device").tag(GameType.single)
            Text("Challenge your device").tag(GameType.bot)
            Text("Challlenge a friend").tag(GameType.peer)

        }
        .pickerStyle(.menu)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
    }
}

#Preview {
    var gameType: GameType = .single
    GameTypePickerView(gameType: .constant(gameType))
}
