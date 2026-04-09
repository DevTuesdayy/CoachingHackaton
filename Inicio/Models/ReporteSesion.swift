//
//  ReporteSesion.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation

struct ReporteSesion: Identifiable {
    let id = UUID()
    let contactoVisual: Int
    let muletillas: Int
    let textoUsuario: String
    let duracionSegundos: Int
    let volumenPromedio: Double
}
