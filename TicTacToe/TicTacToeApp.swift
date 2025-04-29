//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
            } else {
                ContentView(yourName: yourName)
                    .environmentObject(game)
            }
        }
    }
}
