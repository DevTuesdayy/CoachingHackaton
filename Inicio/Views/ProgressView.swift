//
//  ProgressView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI
import Charts

// MARK: - Modelos de Datos
struct ScoreData: Identifiable {
    let id = UUID()
    let day: String
    let score: Int
}

struct Session: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let duration: String
    let score: Int
    
    var scoreColor: Color {
        if score >= 85 { return .green }
        if score >= 75 { return .yellow }
        return .orange
    }
}

// MARK: - Vista Principal
struct ProgressView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    // Datos de la gráfica
    let chartData: [ScoreData] = [
        ScoreData(day: "Lun", score: 65),
        ScoreData(day: "Mar", score: 68),
        ScoreData(day: "Mié", score: 75),
        ScoreData(day: "Jue", score: 72),
        ScoreData(day: "Vie", score: 85),
        ScoreData(day: "Sáb", score: 82),
        ScoreData(day: "Dom", score: 92)
    ]
    
    // Datos del historial
    let sessions: [Session] = [
        Session(title: "Pitch para Inversores", date: "Hoy, 10:00 AM", duration: "4:30", score: 90),
        Session(title: "Presentación de Ventas", date: "Ayer, 16:45", duration: "3:15", score: 82),
        Session(title: "Reunión de Equipo", date: "Jueves, 09:30", duration: "5:00", score: 72),
        Session(title: "Ensayo General", date: "Miércoles, 14:00", duration: "6:20", score: 74)
    ]
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // --- HEADER ---
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Tu Progreso")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(themeManager.primaryTextColor)
                        Text("Análisis detallado de tu comunicación")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // --- TARJETA DE EVOLUCIÓN (GRÁFICA) ---
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Evolución de Score")
                                    .font(.headline)
                                    .foregroundColor(themeManager.primaryTextColor)
                                Text("Últimos 7 días")
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                            Spacer()
                            Text("▲ +15%")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(themeManager.accentColor.opacity(0.2))
                                .foregroundColor(themeManager.accentColor)
                                .cornerRadius(10)
                        }
                        
                        Chart {
                            ForEach(chartData) { item in
                                AreaMark(
                                    x: .value("Día", item.day),
                                    y: .value("Score", item.score)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [themeManager.accentColor.opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .interpolationMethod(.catmullRom)
                                
                                LineMark(
                                    x: .value("Día", item.day),
                                    y: .value("Score", item.score)
                                )
                                .foregroundStyle(themeManager.accentColor)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 180)
                        .chartYScale(domain: 0...100)
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisValueLabel().foregroundStyle(themeManager.secondaryTextColor)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(values: [0, 25, 50, 75, 100]) { _ in
                                AxisGridLine().foregroundStyle(themeManager.borderColor)
                                AxisValueLabel().foregroundStyle(themeManager.secondaryTextColor)
                            }
                        }
                    }
                    .padding(25)
                    .background(themeManager.cardColor)
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(themeManager.borderColor, lineWidth: 1))
                    .padding(.horizontal)
                    
                    // --- METRICAS RÁPIDAS ---
                    HStack(spacing: 15) {
                        ProgressStatCard(title: "92", subtitle: "MEJOR SCORE", icon: "person.fill", iconBg: .purple)
                        ProgressStatCard(title: "85%", subtitle: "CLARIDAD", icon: "bolt.fill", iconBg: .orange)
                    }
                    .padding(.horizontal)
                    
                    // --- HISTORIAL DE SESIONES ---
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Historial de Sesiones")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(themeManager.primaryTextColor)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(sessions) { session in
                                SessionRowView(session: session)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 120) // Espacio para no chocar con el TabBar
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Componentes de Apoyo

struct ProgressStatCard: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let title: String
    let subtitle: String
    let icon: String
    let iconBg: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBg.opacity(0.15))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .foregroundColor(iconBg)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(themeManager.primaryTextColor)
                Text(subtitle)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .kerning(0.5)
            }
            Spacer()
        }
        .padding(.leading, 15)
        .frame(height: 80)
        .background(themeManager.cardColor)
        .cornerRadius(22)
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(themeManager.borderColor, lineWidth: 1))
    }
}

struct SessionRowView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let session: Session
    
    var body: some View {
        HStack(spacing: 15) {
            // Círculo de Score dinámico
            ZStack {
                Circle()
                    .stroke(session.scoreColor.opacity(0.15), lineWidth: 3)
                    .frame(width: 48, height: 48)
                
                Circle()
                    .trim(from: 0, to: CGFloat(session.score) / 100)
                    .stroke(session.scoreColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(-90))
                
                Text("\(session.score)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(session.scoreColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.primaryTextColor)
                
                HStack(spacing: 12) {
                    Label(session.date, systemImage: "calendar")
                    Label(session.duration, systemImage: "clock")
                }
                .font(.system(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(themeManager.borderColor.opacity(2))
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 18)
        .background(themeManager.cardColor)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(themeManager.borderColor, lineWidth: 1))
    }
}

// MARK: - Preview
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(ThemeManager())
    }
}


