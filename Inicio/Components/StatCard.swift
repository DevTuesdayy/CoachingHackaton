//
//  StatCard.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

//COMPONENTES DE APOYO

import SwiftUI

struct StatCard: View {
    var value: String
    var label: String
    var unit: String = ""
    var valueColor: Color = .white
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(valueColor)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.bottom, 5)
                }
            }
            
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(Color.white.opacity(0.05))
        .cornerRadius(22)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        StatCard(value: "85", label: "SCORE PROMEDIO", unit: "/100")
            .padding()
    }
}
