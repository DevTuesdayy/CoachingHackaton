//
//  ReporteSesion.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation

struct ReporteSesion: Identifiable {
    let id = UUID()
    let idioma: IdiomaPractica
    let modoPitch: ModoPitch
    let contactoVisual: Int
    let muletillas: Int
    let textoUsuario: String
    let duracionSegundos: Int
    let volumenPromedio: Double

    static func calcularScore(
        contactoVisual: Int,
        muletillas: Int,
        duracionSegundos: Int,
        volumenPromedio: Double
    ) -> Int {
        let duracionMinutos = max(Double(duracionSegundos) / 60.0, 1.0 / 60.0)
        let muletillasPorMinuto = Double(muletillas) / duracionMinutos

        let contactoScore = Double(max(0, min(100, contactoVisual)))
        let fluidezScore = max(0.0, 100.0 - (muletillasPorMinuto * 7.5))
        let volumenIdeal = 0.58
        let volumenScore = max(0.0, 100.0 - (abs(volumenPromedio - volumenIdeal) * 120.0))

        let finalScore = (contactoScore * 0.55) + (fluidezScore * 0.30) + (volumenScore * 0.15)
        return Int(round(max(0.0, min(100.0, finalScore))))
    }
}
