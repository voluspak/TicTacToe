//
//  ContentView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var game: GameViewModel
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") var yourName: String = ""
    @State private var opponentName: String = ""
    @State private var selectedDifficulty: BotService.Difficulty?
    @State private var startGame: Bool = false
    @State private var changeName = false
    @State private var newName = ""
    @FocusState private var focus: Bool
    @State private var locale: Locale = .current
    
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                GameTypePickerView(gameType: $gameType)
            }
            
            Text(gameType.description)
                .padding()
            
            OpponentConfigView(gameType: $gameType,
                               opponentName: $opponentName,
                               selectDifficulty: $selectedDifficulty,
                               startGame: $startGame,
                               focus: _focus)
            .environmentObject(connectionManager)
            
            if gameType != .peer {
                Button("Start Game") {
                    game.botService.difficulty = selectedDifficulty ?? .easy
                    game.startGame(type: gameType, playerOneName: yourName, playerTwoName: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||
                    gameType == .single && opponentName.isEmpty ||
                    gameType == .bot && selectedDifficulty == nil
                )
                
                Image("LaunchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Text("Your name is \(yourName)")
                
                Button("Change my name") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .navigationTitle("Tic Tac Toe")
        .fullScreenCover(isPresented: $startGame) {
            GameView()
                .environmentObject(connectionManager)
        }
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField("New Name", text: $newName)
            Button("Ok", role: .destructive) {
                yourName = newName
                exit(-1)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Tapping on the Ok button will quit the application so you can relaunch to use your changed name.")
        })
        .environment(\.locale, locale)
        .inNavigationStack()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(yourName: "Ejemplo")
            .environmentObject(GameViewModel())
    }
}
