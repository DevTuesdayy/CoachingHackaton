//
//  ProgressView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI
import Charts
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = ProgressViewModel()
    
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
                            Text(resumenCambio)
                                .font(.system(size: 14, weight: .bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(themeManager.accentColor.opacity(0.2))
                                .foregroundColor(themeManager.accentColor)
                                .cornerRadius(10)
                        }
                        
                        Chart {
                            ForEach(viewModel.chartData) { item in
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
                        ProgressStatCard(title: "\(viewModel.mejorScore)", subtitle: "MEJOR SCORE", icon: "person.fill", iconBg: .purple)
                        ProgressStatCard(title: "\(viewModel.claridadPromedio)%", subtitle: "CLARIDAD", icon: "bolt.fill", iconBg: .orange)
                    }
                    .padding(.horizontal)
                    
                    // --- HISTORIAL DE SESIONES ---
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Historial de Sesiones")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(themeManager.primaryTextColor)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            if viewModel.sessions.isEmpty {
                                emptyHistoryCard
                            } else {
                                ForEach(viewModel.sessions) { session in
                                    SessionRowView(session: session)
                                }
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
        .onAppear {
            viewModel.loadProgress(context: context)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Componentes de Apoyo

extension ProgressView {
    private var resumenCambio: String {
        let scores = viewModel.chartData.map(\.score).filter { $0 > 0 }
        guard let first = scores.first, let last = scores.last, first > 0 else {
            return "Sin datos"
        }

        let change = Int(round((Double(last - first) / Double(first)) * 100))
        return change >= 0 ? "▲ +\(change)%" : "▼ \(change)%"
    }

    private var emptyHistoryCard: some View {
        Text("Aún no hay sesiones guardadas. Completa una práctica para ver tu historial real.")
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(themeManager.secondaryTextColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(themeManager.cardColor)
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(themeManager.borderColor, lineWidth: 1))
    }
}

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
    
    private var scoreColor: Color {
        switch session.scoreColorName {
        case "green":
            .green
        case "yellow":
            .yellow
        default:
            .orange
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Círculo de Score dinámico
            ZStack {
                Circle()
                    .stroke(scoreColor.opacity(0.15), lineWidth: 3)
                    .frame(width: 48, height: 48)
                
                Circle()
                    .trim(from: 0, to: CGFloat(session.score) / 100)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(-90))
                
                Text("\(session.score)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(scoreColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.primaryTextColor)

                Text(session.mode)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(themeManager.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(themeManager.accentColor.opacity(0.12))
                    .clipShape(Capsule(style: .continuous))
                
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
