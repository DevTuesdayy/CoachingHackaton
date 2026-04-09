//
//  ProfileViewModel.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var username: String = "Usuario"
    @Published var email: String = "correo@ejemplo.com"
    @Published var planName: String = "Plan Pro"
    
    func loadCurrentUser(context: ModelContext) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            username = "Usuario"
            email = "correo@ejemplo.com"
            return
        }
        
        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())
            
            if let usuario = usuarios.first(where: {
                $0.email.lowercased() == currentEmail.lowercased()
            }) {
                username = usuario.username
                email = usuario.email
            } else {
                username = "Usuario"
                email = "correo@ejemplo.com"
            }
        } catch {
            username = "Usuario"
            email = "correo@ejemplo.com"
        }
    }
}
