//
//  BotService.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import Foundation

class BotService {
    var difficulty: Difficulty = .easy
    private var corners: [Int] { [1, 3, 7, 9] }
    private var edges: [Int]   { [2, 4, 6, 8] }
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
    
    
    func calculateMove(possibleMoves: [Int], humanMoves: [Int], IAMoves: [Int] = []) async -> Int {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Thinking Simulation
        
        switch difficulty {
        case .easy:
            return possibleMoves.randomElement() ?? 1
        case .medium:
            if let block = twoInARowMove(humanMoves, possibleMoves) {
                return block
            }
            
            return possibleMoves.randomElement() ?? 1
        case .hard:
            return highLevelPlay(humanMoves, possibleMoves, IAMoves)
        }
    }
    
    private func twoInARowMove(_ moves: [Int], _ available: [Int]) -> Int? {
        for line in Move.winningMoves {
            let countInLine = line.filter { moves.contains($0) }.count //Detecta cuantas de esas posiciones están jugadas por el jugador
            
            // Qué posiciones de esa línea aún están libres
            let freeSpots = line.filter { available.contains($0)}
            if countInLine == 2, freeSpots.count == 1 {
                return freeSpots.first
            }
        }
        return nil
    }
    
    private func highLevelPlay(_ humanMoves: [Int], _ possibleMoves: [Int], _ IAMoves: [Int]) -> Int {
        // Win if its possible
        if let win = twoInARowMove(IAMoves, possibleMoves) {
            return win
        }
        
        //Block foe
        if let block = twoInARowMove(humanMoves, possibleMoves) {
            return block
        }
        
        //Center
        if possibleMoves.contains(5) {
            return 5
        }
        
        //Corners
        let freeCorners = corners.filter { possibleMoves.contains($0) }
        if let corner = freeCorners.randomElement() {
            return corner
        }
        
        //Edges
        let freeEdges = edges.filter { possibleMoves.contains($0) }
        if let edge = freeEdges.randomElement() {
            return edge
        }
        
        //Fallback
        return possibleMoves.randomElement() ?? 1
    }
}
