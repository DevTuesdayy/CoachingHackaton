//
//  RegisterViewModel.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Combine
import Foundation
import SwiftData

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

        let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedEmail = normalized(email)
        let normalizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if normalizedUsername.isEmpty
            || normalizedEmail.isEmpty
            || normalizedPassword.isEmpty
        {
            errorMessage = "Completa todos los campos."
            return
        }

        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())

            let existe = usuarios.contains {
                normalized($0.email) == normalizedEmail
            }

            if existe {
                errorMessage = "Ese correo ya está registrado."
                return
            }

            let nuevoUsuario = Usuario(
                username: normalizedUsername,
                email: normalizedEmail,
                password: normalizedPassword
            )
            nuevoUsuario.registrarIngreso()

            context.insert(nuevoUsuario)
            try context.save()
            UserDefaults.standard.set(normalizedEmail, forKey: "currentUserEmail")
            UserDefaults.standard.set(normalizedUsername, forKey: "currentUsername")

            successMessage = "Usuario registrado correctamente."

            username = ""
            email = ""
            password = ""
        } catch {
            errorMessage = "No se pudo registrar el usuario."
        }
    }

    private func normalized(_ email: String) -> String {
        email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
