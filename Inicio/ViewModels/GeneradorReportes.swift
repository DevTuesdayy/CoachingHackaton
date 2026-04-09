//
//  GeneradorReportes.swift
//  Inicio
//
//  Created by Alan Cervantes on 08/04/26.
//

import Foundation
import FoundationModels

class GeneradorReportes{
    
    static func generarReporteReal(contactoVisual: Int, muletillas: Int, textoUsuario: String) async -> String {
        let instrucciones = """
                Eres 'PitchCoach', un coach ejecutivo estricto pero constructivo.
                Analiza las métricas y la transcripción del usuario.
                Devuelve exactamente 3 puntos clave usando viñetas:
                1. Tu mayor fortaleza.
                2. Un área crítica de mejora.
                3. Un consejo práctico accionable.
                No saludes, no uses introducciones, ve directo al análisis. Responde en español.
        """
        
        let contexto = """
                Métricas de esta sesión:
                - Contacto Visual: \(contactoVisual)%
                - Muletillas detectadas: \(muletillas)
                - Transcripción del pitch: "\(textoUsuario)"
        """
        
        do{
            let session = LanguageModelSession(instructions: instrucciones)
                        
            print("Invocando a Apple Intelligence vía Neural Engine...")
                        
            let respuesta = try await session.respond(to: contexto)
                        
            return respuesta.content
        } catch {
            return "Error al generar el reporte local: \(error.localizedDescription)"
        }
    }
}
