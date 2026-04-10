//
//  TabItems.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//


import SwiftUI

struct TabItem: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var icon: String
    var label: String
    var active: Bool = false

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
            
            Text(label)
                .font(.system(size: 11))
        }
        .foregroundColor(active ? themeManager.accentColor : themeManager.iconMutedColor)
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        TabItem(icon: "house.fill", label: "Inicio", active: true)
    }
    .environmentObject(ThemeManager())
}
