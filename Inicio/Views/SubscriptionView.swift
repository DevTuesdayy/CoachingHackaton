//
//  SubscriptionView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        ZStack {
            // Fondo oscuro consistente
            Color(red: 0.02, green: 0.05, blue: 0.12)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    
                    // --- HEADER ---
                    HStack {
                        Button(action: { /* Acción volver */ }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("Planes")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        // Espaciador para centrar el título
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal)
                    
                    // --- TÍTULO PRINCIPAL ---
                    VStack(spacing: 8) {
                        Text("Desbloquea tu")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("potencial real")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.cyan)
                        
                        Text("Práctica ilimitada con feedback inteligente.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(color: .cyan.opacity(0.5), radius: 10)
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
                                .foregroundColor(.cyan)
                                .font(.caption)
                        }
                        if let iconName = icon {
                            Image(systemName: iconName)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !price.isEmpty {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(price)
                            .font(.system(size: 32, weight: .bold))
                        Text(priceDetail)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if !features.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: isPro ? "bolt.fill" : "checkmark.circle")
                                .foregroundColor(isPro ? .cyan : .gray)
                                .font(.system(size: 14))
                            Text(feature)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
            }
            
            Button(action: { /* Acción plan */ }) {
                Text(buttonText)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(isPro ? AnyView(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)) : AnyView(Color.white.opacity(0.1)))
                    .foregroundColor(isPro ? .white : .gray)
                    .cornerRadius(15)
            }
        }
        .padding(25)
        .background(
            ZStack {
                Color.white.opacity(0.05)
                if isPro {
                    // Efecto de brillo para el plan Pro
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(LinearGradient(colors: [.cyan.opacity(0.6), .blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
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
    }
}
