//
//  BotService.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 30/4/25.
//

import Foundation

class BotService {
    var difficulty: Difficulty = .easy
    
    enum Difficulty {
        case easy, medium, hard
    }
    
    func calculateMove(possibleMoves: [Int]) async -> Int {
        try? await Task.sleep(nanoseconds: 1_000_000_000) //thinking simulaiton
        
        switch difficulty {
        case .easy:
            return possibleMoves.randomElement() ?? 1
        case .medium:
            return possibleMoves.randomElement() ?? 1
        case .hard:
            return possibleMoves.randomElement() ?? 1
        }
    }
}
