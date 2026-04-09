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

        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            errorMessage = "Ingresa tu email y contraseña."
            return
        }

        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())

            let usuario = usuarios.first {
                $0.email.lowercased() == email.lowercased()
                    && $0.password == password
            }

            if let usuario {
                usuario.registrarIngreso()
                try context.save()
                UserDefaults.standard.set(usuario.email, forKey: "currentUserEmail")
                successMessage = "Inicio de sesión correcto."
            } else {
                errorMessage = "Correo o contraseña incorrectos."
            }
        } catch {
            errorMessage = "No se pudo iniciar sesión."
        }
    }
}
