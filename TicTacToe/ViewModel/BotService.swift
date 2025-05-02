//
//  BotService.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import Foundation

class BotService {
    var difficulty: Difficulty = .easy
    
    enum Difficulty: CaseIterable {
        case easy, medium, hard
        
        var label: String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }
    }
    
    func calculateMove(possibleMoves: [Int], humanMoves: [Int]) async -> Int {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Thinking Simulation
        
        switch difficulty {
        case .easy:
            return possibleMoves.randomElement() ?? 1
        case .medium:
            if let block = blockingMove(humanMoves, possibleMoves) {
                return block
            }
            
            return possibleMoves.randomElement() ?? 1
        case .hard:
            return possibleMoves.randomElement() ?? 1
        }
    }
    
    private func blockingMove(_ opponentMoves: [Int], _ available: [Int]) -> Int? {
        for line in Move.winningMoves {
            let countInLine = line.filter { opponentMoves.contains($0) }.count //Detecta cuantas de esas posiciones están jugadas por el jugador
            
            // Qué posiciones de esa línea aún están libres
            let freeSpots = line.filter { available.contains($0)}
            if countInLine == 2, freeSpots.count == 1 {
                return freeSpots.first
            }
        }
        return nil
    }
}
