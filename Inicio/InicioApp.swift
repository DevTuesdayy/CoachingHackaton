//
//  InicioApp.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 06/04/26.
//

import SwiftUI
import SwiftData

@main
struct InicioApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
        .modelContainer(for: Usuario.self)
    }
}
