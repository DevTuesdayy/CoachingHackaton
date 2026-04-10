//
//  AppBAckgroundView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct AppBackgroundView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        themeManager.backgroundColor
            .ignoresSafeArea()
    }
}
