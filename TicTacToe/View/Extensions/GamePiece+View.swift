//
//  GamePiece+View.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 30/4/25.
//

import SwiftUI

extension GamePiece {
    var image: Image{
        Image(self.rawValue)
    }
}

extension GameSquare {
    var image: Image {
        if let player = player {
            return player.gamePiece.image
        } else {
            return Image("none")
        }
    }
}
