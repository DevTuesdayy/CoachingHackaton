//
//  CircleIconButton.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct CircleIconButton: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(themeManager.primaryTextColor)
                .frame(width: 66, height: 66)
                .background(themeManager.elevatedCardColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(themeManager.borderColor, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
