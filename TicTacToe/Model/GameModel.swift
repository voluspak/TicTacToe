//
//  GameModel.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import Foundation

enum GameType {
    case single, bot, peer, undetermined
    
    var description: String {
        switch self  {
        case .single:
            return "Share your iPhone/iPad and play against a friend"
        case .bot:
            return "Play against this iPhone/iPad"
        case .peer:
            return "Invite someone near you who has this app and running to play"
        case .undetermined:
            return ""
        }
    }
}
