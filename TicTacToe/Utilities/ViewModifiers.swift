//
//  ViewModifiers.swift
//  TicTacToe
//
//  Created by Ivan Telleria on 18/4/25.
//

import SwiftUI

struct NavStackContainer: ViewModifier {
    @State private var locale: Locale = .current
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content
                LanguageSelectorView(locale: $locale)
            }
            .environment(\.locale, locale)
        } else {
            NavigationView {
                content
                LanguageSelectorView(locale: $locale)
            }
            .navigationViewStyle(.stack)
            .environment(\.locale, locale)

        }
    }
}

extension View {
    public func inNavigationStack() -> some View {
        return self.modifier(NavStackContainer())
    }
}
