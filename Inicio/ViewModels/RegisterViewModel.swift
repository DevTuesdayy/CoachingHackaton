//
//  LoginView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var errorMessage = ""
    @Published var successMessage = ""
    
    func register(context: ModelContext) {
        errorMessage = ""
        successMessage = ""
        
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Completa todos los campos."
            return
        }
        
        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())
            
            let existe = usuarios.contains {
                $0.email.lowercased() == email.lowercased()
            }
            
            if existe {
                errorMessage = "Ese correo ya está registrado."
                return
            }
            
            let nuevoUsuario = Usuario(
                username: username,
                email: email,
                password: password
            )
            
            context.insert(nuevoUsuario)
            try context.save()
            
            successMessage = "Usuario registrado correctamente."
            
            username = ""
            email = ""
            password = ""
        } catch {
            errorMessage = "No se pudo registrar el usuario."
        }
    }
}
