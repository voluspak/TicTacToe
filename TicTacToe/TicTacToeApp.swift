//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(game)
        }
    }
}
