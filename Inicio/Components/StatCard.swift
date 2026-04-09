//
//  StatCard.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

//COMPONENTES DE APOYO

import SwiftUI

struct StatCard: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var value: String
    var label: String
    var unit: String = ""
    var valueColor: Color? = nil

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(valueColor ?? themeManager.primaryTextColor)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.secondaryTextColor.opacity(0.8))
                        .padding(.bottom, 5)
                }
            }
            
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(themeManager.cardColor)
        .cornerRadius(22)
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        StatCard(value: "85", label: "SCORE PROMEDIO", unit: "/100")
            .padding()
    }
    .environmentObject(ThemeManager())
}
