//
//  Usuario.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftData

@Model
final class Usuario {
    var username: String
    var email: String
    var password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}
