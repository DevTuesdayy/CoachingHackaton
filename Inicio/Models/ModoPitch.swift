//
//  ModoPitch.swift
//  Inicio
//
//  Created by Codex on 10/04/26.
//

import Foundation

enum ModoPitch: String, CaseIterable, Identifiable, Codable {
    case ventas
    case elevador
    case clase
    case startup

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ventas:
            "Ventas"
        case .elevador:
            "Elevador"
        case .clase:
            "Clase"
        case .startup:
            "Startup Pitch"
        }
    }

    var guidance: String {
        switch self {
        case .ventas:
            "Prioriza persuasion, energia, claridad del valor y un cierre con llamada a la accion."
        case .elevador:
            "Prioriza brevedad, claridad inmediata, estructura compacta y mensaje memorable."
        case .clase:
            "Prioriza explicacion ordenada, ritmo didactico, volumen estable y contacto visual sostenido."
        case .startup:
            "Prioriza problema, solucion, diferenciador, mercado y confianza al presentar."
        }
    }

    var practicePrompt: String {
        switch self {
        case .ventas:
            "Practica un pitch de ventas convincente."
        case .elevador:
            "Practica un elevator pitch corto y claro."
        case .clase:
            "Practica una explicacion clara como si dieras una clase."
        case .startup:
            "Practica un startup pitch para inversionistas o jurado."
        }
    }
}
