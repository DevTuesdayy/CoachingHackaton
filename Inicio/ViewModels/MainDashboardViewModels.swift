//
//  MainDashboardViewModel.swift
//
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class MainDashboardViewModel: ObservableObject {
    @Published var username: String = "Usuario"
    @Published var planName: String = "Plan Pro"
    @Published var planStatus: String = "Activo"
    
    func loadCurrentUser(context: ModelContext) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            username = "Usuario"
            return
        }
        
        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())
            
            if let usuario = usuarios.first(where: {
                $0.email.lowercased() == currentEmail.lowercased()
            }) {
                username = usuario.username
            } else {
                username = "Usuario"
            }
        } catch {
            username = "Usuario"
        }
    }
}
