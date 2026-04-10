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
    @Published var totalSesiones: Int = 0
    @Published var mejorScore: Int = 0
    @Published var claridadPromedio: Int = 0
    
    func loadCurrentUser(context: ModelContext) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            username = "Usuario"
            email = "correo@ejemplo.com"
            totalSesiones = 0
            mejorScore = 0
            claridadPromedio = 0
            return
        }
        
        do {
            let usuarios = try context.fetch(FetchDescriptor<Usuario>())
            let sesionesDescriptor = FetchDescriptor<SesionPractica>(
                predicate: #Predicate<SesionPractica> { sesion in
                    sesion.userEmail == currentEmail
                },
                sortBy: [SortDescriptor(\.fecha, order: .reverse)]
            )
            let sesiones = try context.fetch(sesionesDescriptor)
            
            if let usuario = usuarios.first(where: {
                $0.email.lowercased() == currentEmail.lowercased()
            }) {
                username = usuario.username
                email = usuario.email
            } else {
                username = "Usuario"
                email = "correo@ejemplo.com"
            }

            totalSesiones = sesiones.count
            mejorScore = sesiones.map(\.scorePromedio).max() ?? 0
            claridadPromedio = sesiones.isEmpty
                ? 0
                : Int(round(sesiones.map { Double($0.contactoVisual) }.reduce(0, +) / Double(sesiones.count)))
        } catch {
            username = "Usuario"
            email = "correo@ejemplo.com"
            totalSesiones = 0
            mejorScore = 0
            claridadPromedio = 0
        }
    }
}
