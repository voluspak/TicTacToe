//
//  GameSquare+Piece.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import SwiftUI

extension GameSquare {
    var image: Image {
        if let player = player {
            return player.gamePiece.image
        } else {
            return Image("none")
        }
    }
}

extension GamePiece {
    var image: Image{
        Image(self.rawValue)
    }
}
