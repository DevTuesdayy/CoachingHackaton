//
//  Usuario.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation
import SwiftData

@Model
final class Usuario {
    var username: String
    var email: String
    var password: String
    var rachaActual: Int
    var mejorRacha: Int
    var ultimaFechaIngreso: Date?

    init(
        username: String,
        email: String,
        password: String,
        rachaActual: Int = 0,
        mejorRacha: Int = 0,
        ultimaFechaIngreso: Date? = nil
    ) {
        self.username = username
        self.email = email
        self.password = password
        self.rachaActual = rachaActual
        self.mejorRacha = mejorRacha
        self.ultimaFechaIngreso = ultimaFechaIngreso
    }

    func registrarIngreso(fecha: Date = .now, calendar: Calendar = .current) {
        guard let ultimaFechaIngreso else {
            rachaActual = 1
            mejorRacha = max(mejorRacha, rachaActual)
            self.ultimaFechaIngreso = fecha
            return
        }

        if calendar.isDate(ultimaFechaIngreso, inSameDayAs: fecha) {
            return
        }

        let diaAnterior = calendar.startOfDay(for: ultimaFechaIngreso)
        let diaActual = calendar.startOfDay(for: fecha)
        let diasTranscurridos = calendar.dateComponents([.day], from: diaAnterior, to: diaActual).day ?? 0

        if diasTranscurridos == 1 {
            rachaActual += 1
        } else {
            rachaActual = 1
        }

        mejorRacha = max(mejorRacha, rachaActual)
        self.ultimaFechaIngreso = fecha
    }
}
