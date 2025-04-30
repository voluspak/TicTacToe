//
//  MPPeersView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 29/4/25.
//

import SwiftUI

struct MPPeersView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameViewModel
    @Binding var startGame: Bool
    var body: some View {
        VStack {
            Text("Available Players")
            List(connectionManager.availablePeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName)
                    Spacer()
                    Button("Select") {
                        game.gameType = .peer
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        game.playerOne.name = connectionManager.myPeerId.displayName
                        game.playerTwo.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alert("Received Invitation From \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite, actions: {
                    Button("Accept") {
                        if let invitationHandle = connectionManager.invitationHandler {
                            invitationHandle(true, connectionManager.session)
                            game.playerOne.name = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
                            game.playerTwo.name = connectionManager.myPeerId.displayName
                            game.gameType = .peer
                        }
                    }
                    Button("Reject"){
                        if let invitationHandle = connectionManager.invitationHandler {
                                invitationHandle(false, nil)
                        }
                    }
                })
            }
        }
        .onAppear {
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.isAvailableToPlay = false
            connectionManager.stopAdvertising()
            connectionManager.stopBrowsing()
        }
        .onChange(of: connectionManager.paired) { newValue in
            startGame = newValue
        }
    }
}

struct MPPeersView_Previews: PreviewProvider {
    static var previews: some View {
        MPPeersView(startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(GameService())
    }
}
