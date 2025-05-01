//
//  YourName.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 25/4/25.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var username = ""
    var body: some View {
        VStack{
            Text("This name is the name that will be associated with this device.")
            TextField("Your name", text: $username)
                .textFieldStyle(.roundedBorder)
            Button("Set"){
                yourName = username
            }
            .buttonStyle(.borderedProminent)
            .disabled(username.isEmpty)
            Image("LaunchScreen")
            Spacer()
        }
        .padding()
        .navigationTitle("TicTacToe")
        .inNavigationStack()
    }
}

struct YourNameView_Previews: PreviewProvider {
    static var previews: some View {
        YourNameView()
    }
}
