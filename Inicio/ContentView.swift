//
//  ContentView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 06/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
