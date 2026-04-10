//
//  LoginViewModel.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    @Published var errorMessage = ""
    @Published var successMessage = ""

    func login(context: ModelContext) {
        errorMessage = ""
        successMessage = ""

        let normalizedEmail = normalized(email)
        let normalizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if normalizedEmail.isEmpty
            || normalizedPassword.isEmpty
        {
            errorMessage = "Ingresa tu email y contraseña."
            return
        }

        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())

            let usuario = usuarios.first {
                normalized($0.email) == normalizedEmail
                    && $0.password == normalizedPassword
            }

            if let usuario {
                usuario.email = normalized(usuario.email)
                usuario.registrarIngreso()
                try context.save()
                UserDefaults.standard.set(usuario.email, forKey: "currentUserEmail")
                UserDefaults.standard.set(usuario.username, forKey: "currentUsername")
                successMessage = "Inicio de sesión correcto."
            } else {
                errorMessage = "Correo o contraseña incorrectos."
            }
        } catch {
            errorMessage = "No se pudo iniciar sesión."
        }
    }

    private func normalized(_ email: String) -> String {
        email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
