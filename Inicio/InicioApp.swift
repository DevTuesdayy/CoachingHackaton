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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Usuario.self)
    }
}
