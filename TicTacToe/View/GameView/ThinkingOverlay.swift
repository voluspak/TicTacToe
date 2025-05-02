//
//  ThinkingOverlay.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 1/5/25.
//

import SwiftUI

struct ThinkingOverlay: View {
    var body: some View {
        VStack{
                Text("Thinking...")
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .background(Color.primary)
            ProgressView()
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(8)
    }
}

#Preview {
    ThinkingOverlay()
}
