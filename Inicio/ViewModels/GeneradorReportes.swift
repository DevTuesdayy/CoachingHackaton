//
//  GeneradorReportes.swift
//  Inicio
//
//  Created by Alan Cervantes on 08/04/26.
//

import Foundation
import Combine
import FoundationModels

@Generable(description: "Analisis completo de una sesion de pitch")
struct AnalisisSesionIA {
    var insights: [String]
    var timelineChart: [PuntoTimelineIA]
    var timelineEvents: [EventoTimelineIA]
}

@Generable(description: "Punto del score en una linea de tiempo")
struct PuntoTimelineIA {
    var time: String
    var score: Int
}

@Generable(description: "Evento clave dentro de la sesion")
struct EventoTimelineIA {
    var time: String
    var title: String
}

@MainActor
final class GeneradorReportes: ObservableObject {
    @Published var analisisGenerado: AnalisisSesionIA?
    @Published var estaGenerando = false
    @Published var mensajeError: String?

    func generarReporte(
        contactoVisual: Int,
        muletillas: Int,
        textoUsuario: String,
        duracionSegundos: Int,
        volumenPromedio: Double
    ) async {
        estaGenerando = true
        mensajeError = nil
        analisisGenerado = nil

        let instrucciones = """
        Eres 'PitchCoach', un coach ejecutivo estricto pero constructivo.
        Analiza las métricas y la transcripción del usuario.
        Responde en español con una estructura coherente y realista.
        Genera exactamente 3 insights breves.
        Genera exactamente 6 puntos para timelineChart distribuidos entre 0:00 y la duracion real de la sesion.
        Genera exactamente 3 eventos para timelineEvents con momentos importantes del pitch.
        Los scores y eventos deben ser consistentes con el contacto visual, las muletillas, el volumen de voz y el contenido del pitch.
        Nunca inventes tiempos fuera de la duracion real.
        """

        let contexto = """
        Métricas de esta sesión:
        - Contacto Visual: \(contactoVisual)%
        - Muletillas detectadas: \(muletillas)
        - Duración total: \(duracionSegundos) segundos
        - Volumen promedio de voz: \(Int(volumenPromedio * 100))%
        - Transcripción del pitch: "\(textoUsuario)"
        """

        do {
            let session = LanguageModelSession(instructions: instrucciones)
            let respuesta = try await session.respond(
                to: contexto,
                generating: AnalisisSesionIA.self
            )
            analisisGenerado = respuesta.content
        } catch {
            analisisGenerado = nil
            mensajeError = "No se pudo generar el reporte: \(error.localizedDescription)"
        }

        estaGenerando = false
    }
}
