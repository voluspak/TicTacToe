//
//  MPGameMove.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 29/4/25.
//

import Foundation

struct MPGameMove: Codable {
    enum Action: Int, Codable {
        case start, move, reset, end
    }
    
    let action: Action
    let playerName: String?
    let index: Int?
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
