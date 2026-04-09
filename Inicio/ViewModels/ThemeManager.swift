//
//  ThemeManager.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI
import Combine

final class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = true

    var backgroundColor: Color {
        isDarkMode ? Color(red: 0.02, green: 0.05, blue: 0.12) : Color(white: 0.95)
    }

    var backgroundSecondaryColor: Color {
        isDarkMode ? Color(red: 0.05, green: 0.08, blue: 0.15) : Color(red: 0.90, green: 0.95, blue: 1.0)
    }

    var cardColor: Color {
        isDarkMode ? Color.white.opacity(0.05) : Color.white
    }

    var elevatedCardColor: Color {
        isDarkMode ? Color.white.opacity(0.08) : Color.white.opacity(0.92)
    }

    var fieldBackgroundColor: Color {
        isDarkMode ? Color.black.opacity(0.30) : Color.black.opacity(0.04)
    }

    var primaryTextColor: Color {
        isDarkMode ? .white : .black
    }

    var secondaryTextColor: Color {
        isDarkMode ? .gray : .gray.opacity(0.8)
    }

    var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08)
    }

    var accentColor: Color {
        .cyan
    }

    var accentSecondaryColor: Color {
        .blue
    }

    var accentGradient: LinearGradient {
        LinearGradient(
            colors: [accentColor, accentSecondaryColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var successColor: Color {
        .green
    }

    var warningColor: Color {
        .orange
    }

    var dangerColor: Color {
        .red
    }

    var iconMutedColor: Color {
        isDarkMode ? .gray : .gray.opacity(0.9)
    }

    var overlayColor: Color {
        isDarkMode ? Color.black.opacity(0.55) : Color.white.opacity(0.75)
    }

    func toggleTheme() {
        withAnimation(.easeInOut) {
            isDarkMode.toggle()
        }
    }
}
