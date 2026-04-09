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
    @Published var totalSesiones: Int = 0
    @Published var ultimoScorePromedio: Int = 0

    func loadCurrentUser(context: ModelContext) {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            username = "Usuario"
            totalSesiones = 0
            ultimoScorePromedio = 0
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
            } else {
                username = "Usuario"
            }

            totalSesiones = sesiones.count
            ultimoScorePromedio = sesiones.first?.scorePromedio ?? 0
        } catch {
            username = "Usuario"
            totalSesiones = 0
            ultimoScorePromedio = 0
        }
    }

    func registrarSesion(reporte: ReporteSesion, context: ModelContext) async {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            return
        }

        let score = ReporteSesion.calcularScore(
            contactoVisual: reporte.contactoVisual,
            muletillas: reporte.muletillas,
            duracionSegundos: reporte.duracionSegundos,
            volumenPromedio: reporte.volumenPromedio
        )
        let temaPrincipal = await GeneradorReportes.analizarTema(textoUsuario: reporte.textoUsuario)
        let sesion = SesionPractica(
            userEmail: currentEmail,
            duracionSegundos: reporte.duracionSegundos,
            contactoVisual: reporte.contactoVisual,
            muletillas: reporte.muletillas,
            volumenPromedio: reporte.volumenPromedio,
            textoUsuario: reporte.textoUsuario,
            temaPrincipal: temaPrincipal,
            scorePromedio: score
        )

        context.insert(sesion)

        do {
            try context.save()
            loadCurrentUser(context: context)
        } catch {
            context.delete(sesion)
        }
    }
}
