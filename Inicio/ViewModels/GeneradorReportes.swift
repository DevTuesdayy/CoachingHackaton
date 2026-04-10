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
        idioma: IdiomaPractica,
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
        Responde en \(idioma == .espanol ? "español" : "inglés") con una estructura coherente y realista.
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

    static func analizarTema(textoUsuario: String, idioma: IdiomaPractica) async -> String {
        let textoLimpio = textoUsuario.trimmingCharacters(in: .whitespacesAndNewlines)
        let listeningPlaceholder = idioma.listeningPlaceholder
        guard !textoLimpio.isEmpty, textoLimpio != listeningPlaceholder else {
            return idioma == .espanol ? "Práctica general" : "General practice"
        }

        let instrucciones = """
        Identify the main topic of a speech or pitch.
        Return a short topic in \(idioma == .espanol ? "Spanish" : "English"), between 2 and 5 words.
        It must be a clear category or subject, not a long sentence.
        """

        do {
            let session = LanguageModelSession(instructions: instrucciones)
            let respuesta = try await session.respond(
                to: "Texto del speech: \"\(textoLimpio)\"",
                generating: TemaSesionIA.self
            )
            let tema = respuesta.content.tema.trimmingCharacters(in: .whitespacesAndNewlines)
            return tema.isEmpty ? fallbackTema(from: textoLimpio, idioma: idioma) : tema
        } catch {
            return fallbackTema(from: textoLimpio, idioma: idioma)
        }
    }

    private static func fallbackTema(from texto: String, idioma: IdiomaPractica) -> String {
        let palabras = texto
            .components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
            .filter { !$0.isEmpty }
            .prefix(4)

        let candidato = palabras.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        if !candidato.isEmpty {
            return candidato
        }

        return idioma == .espanol ? "Práctica general" : "General practice"
    }
}
