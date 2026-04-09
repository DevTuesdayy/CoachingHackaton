//
//  MainDashboardView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//
import SwiftUI

struct MainDashboardView: View {
        @StateObject private var entrenadorVoz = EntrenadorDeVoz()
        @State private var isDarkMode = true
        @State private var mostrarPracticaEnVivo = false
        
        // 2. Definición de colores dinámicos
        private var backgroundColor: Color {
            isDarkMode ? Color(red: 0.02, green: 0.05, blue: 0.12) : Color(white: 0.95)
        }
        
        private var cardColor: Color {
            isDarkMode ? Color.white.opacity(0.05) : Color.white
        }
        
        private var textColor: Color {
            isDarkMode ? .white : .black
        }
    
    var body: some View {
        ZStack {
            // Fondo oscuro profundo
            Color(red: 0.02, green: 0.05, blue: 0.12)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // --- HEADER ---
                        HStack {
                            ZStack(alignment: .bottomTrailing) {
                                // Imagen de perfil (usando icono de sistema por defecto)
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.cyan, lineWidth: 2))
                                
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 14, height: 14)
                                    .overlay(Circle().stroke(Color(red: 0.02, green: 0.05, blue: 0.12), lineWidth: 2))
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Hola, Sofia") // Texto estático de nuevo
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Plan Pro • Activo")
                                    .font(.system(size: 14))
                                    .foregroundColor(.cyan)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    isDarkMode.toggle()
                                }
                            }) {
                                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(isDarkMode ? .yellow : .blue)
                                                                .padding(12)
                                                                .background(cardColor)
                                                                .clipShape(Circle())
                                                                .shadow(color: Color.black.opacity(isDarkMode ? 0 : 0.1), radius: 5)
                                                        }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // --- TARJETA PRINCIPAL: INICIAR PRÁCTICA ---
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(Color.cyan.opacity(0.1))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.cyan)
                            }
                            
                            Text("Iniciar Práctica")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("IA lista para analizar tu pitch")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 35)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.blue.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(LinearGradient(colors: [.cyan.opacity(0.8), .blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                                )
                        )
                        .padding(.horizontal)
                        .onTapGesture {
                            mostrarPracticaEnVivo = true
                        }
                        
                        // --- ESTADÍSTICAS (SESIONES Y SCORE) ---
                        HStack(spacing: 15) {
                            StatCard(value: "12", label: "SESIONES")
                            StatCard(value: "85", label: "SCORE PROMEDIO", unit: "/100", valueColor: Color(red: 0.2, green: 0.9, blue: 0.5))
                        }
                        .padding(.horizontal)
                        
                        // --- SECCIÓN PROGRESO SEMANAL ---
                        VStack(spacing: 15) {
                            HStack {
                                Text("Progreso Semanal")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Button("Ver todo >") { }
                                    .font(.system(size: 14))
                                    .foregroundColor(.cyan)
                            }
                            .padding(.horizontal)
                            
                            // Tarjeta de Fluidez con Gráfica
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    ZStack {
                                        Circle().fill(Color.purple.opacity(0.2)).frame(width: 38, height: 38)
                                        Image(systemName: "bolt.fill").foregroundColor(.purple)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Fluidez verbal")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                        Text("Has reducido tus muletillas un 15%")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.green)
                                        .padding(8)
                                        .background(Color.green.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                
                                // Gráfica de Barras
                                BarChartView()
                            }
                            .padding(20)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 100)
                }
                
                // --- CUSTOM TAB BAR ---
                HStack {
                    TabItem(icon: "house.fill", label: "Inicio", active: true)
                    Spacer()
                    TabItem(icon: "chart.bar.fill", label: "Progreso")
                    Spacer()
                    TabItem(icon: "creditcard.fill", label: "Pro")
                    Spacer()
                    TabItem(icon: "person.fill", label: "Perfil")
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Color(red: 0.02, green: 0.05, blue: 0.12).opacity(0.95))
                .overlay(Rectangle().frame(height: 0.5).foregroundColor(.white.opacity(0.1)), alignment: .top)
            }
        }
        .fullScreenCover(isPresented: $mostrarPracticaEnVivo) {
                    VistaPracticaEnVivo(entrenadorVoz: entrenadorVoz)
                }
    }
}

//COMPONENTES DE APOYO

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

struct BarChartView: View {
    let heights: [CGFloat] = [0.3, 0.5, 0.4, 0.8, 0.6, 0.9, 0.7]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(heights.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(colors: [.cyan, .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                    .frame(height: heights[i] * 80)
            }
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
    }
}

struct TabItem: View {
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
        .foregroundColor(active ? .cyan : .gray)
    }
}

struct MainDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        MainDashboardView()
    }
}

