//
//  SesionPractica.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation
import SwiftData

@Model
final class SesionPractica {
    var userEmail: String
    var fecha: Date
    var duracionSegundos: Int
    var contactoVisual: Int
    var muletillas: Int
    var volumenPromedio: Double
    var textoUsuario: String
    var temaPrincipal: String
    var scorePromedio: Int

    init(
        userEmail: String,
        fecha: Date = .now,
        duracionSegundos: Int,
        contactoVisual: Int,
        muletillas: Int,
        volumenPromedio: Double,
        textoUsuario: String,
        temaPrincipal: String,
        scorePromedio: Int
    ) {
        self.userEmail = userEmail
        self.fecha = fecha
        self.duracionSegundos = duracionSegundos
        self.contactoVisual = contactoVisual
        self.muletillas = muletillas
        self.volumenPromedio = volumenPromedio
        self.textoUsuario = textoUsuario
        self.temaPrincipal = temaPrincipal
        self.scorePromedio = scorePromedio
    }
}
