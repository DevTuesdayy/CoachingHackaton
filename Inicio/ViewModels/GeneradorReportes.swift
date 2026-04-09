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

@Generable(description: "Tema principal del discurso")
struct TemaSesionIA {
    var tema: String
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

    static func analizarTema(textoUsuario: String) async -> String {
        let textoLimpio = textoUsuario.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textoLimpio.isEmpty, textoLimpio != "Escuchando..." else {
            return "Práctica general"
        }

        let instrucciones = """
        Identifica el tema principal de un speech o pitch.
        Devuelve un tema breve en español, de entre 2 y 5 palabras.
        Debe ser una categoria o asunto claro, no una frase larga.
        """

        do {
            let session = LanguageModelSession(instructions: instrucciones)
            let respuesta = try await session.respond(
                to: "Texto del speech: \"\(textoLimpio)\"",
                generating: TemaSesionIA.self
            )
            let tema = respuesta.content.tema.trimmingCharacters(in: .whitespacesAndNewlines)
            return tema.isEmpty ? fallbackTema(from: textoLimpio) : tema
        } catch {
            return fallbackTema(from: textoLimpio)
        }
    }

    private static func fallbackTema(from texto: String) -> String {
        let palabras = texto
            .components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
            .filter { !$0.isEmpty }
            .prefix(4)

        let candidato = palabras.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        return candidato.isEmpty ? "Práctica general" : candidato
    }
}
