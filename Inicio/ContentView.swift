//
//  ContentView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 06/04/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("currentUserEmail") private var currentUserEmail = ""

    var body: some View {
        NavigationStack {
            if currentUserEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                WelcomeView()
            } else {
                MainDashboardView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
