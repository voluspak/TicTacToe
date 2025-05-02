//
//  DifficultyPickerView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 2/5/25.
//

import SwiftUI

struct DifficultyPickerView: View {
    @Binding var selection: BotService.Difficulty?
    
    var body: some View {
        Picker("Difficulty", selection: $selection) {
            Text("Select Difficulty").tag(BotService.Difficulty?.none)
            ForEach(BotService.Difficulty.allCases, id: \.self) { level in
                Text(level.label).tag(Optional(level))
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
    }
}

#Preview {
    var selection: BotService.Difficulty? = .easy
    DifficultyPickerView(selection: .constant(selection))
}
