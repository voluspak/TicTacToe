//
//  LanguageSelectorView.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 2/5/25.
//

import SwiftUI

struct LanguageSelectorView: View {
    @Binding var locale: Locale
    
    var body: some View {
        Menu {
            Button(action: { locale = Locale(identifier: "en") }) {
                Label("English", systemImage: "flag.us")
            }
            Button(action: { locale = Locale(identifier: "es") }) {
                Label("Español", systemImage: "flag.sp")
            }
        } label: {
            Image(systemName: "globe")
                .font(.title2)
                .padding(8)
        }
    }
}

#Preview {
    var locale = Locale(identifier: "en")
    LanguageSelectorView(locale: .constant(locale))
}
