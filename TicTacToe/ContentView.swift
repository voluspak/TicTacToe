//
//  ContentView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: GameService
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") var yourName: String = ""
    @State private var opponentName: String = ""
    @FocusState private var focus: Bool
    @State private var startGame: Bool = false
    @State private var changeName = false
    @State private var newName = ""
    init(yourName: String) {
        self.yourName = yourName
    }
    
    var body: some View {
        VStack { 
            Picker("Select Game", selection: $gameType) {
                Text("Select Game Type").tag(GameType.undetermined)
                Text("Two Sharing Device").tag(GameType.single)
                Text("Challenge your device").tag(GameType.bot)
                Text("Challlenge a friend").tag(GameType.peer)

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
            Text(gameType.description)
                .padding()
            VStack{
                switch gameType {
                case .single:
                        TextField("Opponent Name", text: $opponentName)
                case .bot:
                    EmptyView()
                case .peer:
                    EmptyView()
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            if gameType != .peer {
                Button("Start Game") {
                    game.setupGame(gameType: gameType, playerOneName: yourName, playerTwoName: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||
                    gameType == .single && opponentName.isEmpty
                )
                Image("LaunchScreen")
                Text("Your name is \(yourName)")
                Button("Change my namne") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .navigationTitle("Tic Tac Toe")
        .fullScreenCover(isPresented: $startGame) {
            GameView()
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
        .inNavigationStack()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(yourName: "Ejemplo")
            .environmentObject(GameService())
    }
}
