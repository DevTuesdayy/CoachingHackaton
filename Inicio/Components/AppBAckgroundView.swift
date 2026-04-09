//
//  AppBAckgroundView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [Color(red: 0.1, green: 0.2, blue: 0.4), Color.black]),
            center: .top,
            startRadius: 100,
            endRadius: 900
        )
        .ignoresSafeArea()
    }
}
