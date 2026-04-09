//
//  SubscriptionView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    
                    // --- HEADER ---
                    HStack {
                        Button(action: { /* Acción volver */ }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(themeManager.primaryTextColor)
                                .padding(12)
                                .background(themeManager.elevatedCardColor)
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("Planes")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        Spacer()
                        // Espaciador para centrar el título
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal)
                    
                    // --- TÍTULO PRINCIPAL ---
                    VStack(spacing: 8) {
                        Text("Desbloquea tu")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(themeManager.primaryTextColor)
                        Text("potencial real")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(themeManager.accentColor)
                        
                        Text("Práctica ilimitada con feedback inteligente.")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .padding(.top, 5)
                    }
                    .multilineTextAlignment(.center)
                    
                    // --- PLAN BÁSICO ---
                    PlanCard(
                        title: "Básico",
                        price: "Gratis",
                        subtitle: "Para probar la experiencia",
                        features: ["5 sesiones al mes", "Feedback básico"],
                        buttonText: "Tu plan actual",
                        isPro: false
                    ).foregroundColor(.white)
                    
                    // --- PLAN PRO (MÁS POPULAR) ---
                    ZStack(alignment: .topTrailing) {
                        PlanCard(
                            title: "Pro",
                            price: "$99",
                            subtitle: "Sin límites, mejora diaria",
                            features: ["Sesiones ilimitadas", "Análisis avanzado (ritmo, muletillas)", "Historial y progreso detallado"],
                            buttonText: "Mejorar a Pro",
                            isPro: true,
                            priceDetail: "MXN / mes"
                        ).foregroundColor(.white)
                        
                        // Etiqueta "Más Popular"
                        Text("MÁS POPULAR")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(themeManager.accentColor)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(color: themeManager.accentColor.opacity(0.5), radius: 10)
                            .offset(x: -20, y: -10)
                    }
                    
                    // --- PLAN CORPORATIVO ---
                    PlanCard(
                        title: "Corporativo",
                        price: "",
                        subtitle: "Para equipos de ventas y liderazgo",
                        features: [],
                        buttonText: "Contactar ventas",
                        isPro: false,
                        icon: "building.2.fill"
                    ).foregroundColor(.white)
                }
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
    }
}

// MARK: - Componente PlanCard
struct PlanCard: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let title: String
    let price: String
    let subtitle: String
    let features: [String]
    let buttonText: String
    let isPro: Bool
    var priceDetail: String = ""
    var icon: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.title2)
                            .bold()
                        if isPro {
                            Image(systemName: "star.fill")
                                .foregroundColor(themeManager.accentColor)
                                .font(.caption)
                        }
                        if let iconName = icon {
                            Image(systemName: iconName)
                                .font(.caption)
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                    }
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                if !price.isEmpty {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(price)
                            .font(.system(size: 32, weight: .bold))
                        Text(priceDetail)
                            .font(.caption2)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
            }
            
            if !features.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: isPro ? "bolt.fill" : "checkmark.circle")
                                .foregroundColor(isPro ? themeManager.accentColor : themeManager.secondaryTextColor)
                                .font(.system(size: 14))
                            Text(feature)
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.primaryTextColor.opacity(0.9))
                        }
                    }
                }
            }
            
            Button(action: { /* Acción plan */ }) {
                Text(buttonText)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(isPro ? AnyView(themeManager.accentGradient) : AnyView(themeManager.elevatedCardColor))
                    .foregroundColor(isPro ? .white : themeManager.secondaryTextColor)
                    .cornerRadius(15)
            }
        }
        .padding(25)
        .background(
            ZStack {
                themeManager.cardColor
                if isPro {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.accentColor.opacity(0.6),
                                    themeManager.accentSecondaryColor.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                }
            }
        )
        .cornerRadius(30)
        .padding(.horizontal)
    }
}

// Preview
struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
            .environmentObject(ThemeManager())
    }
}
