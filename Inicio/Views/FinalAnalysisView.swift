//
//  AnalisisFinalView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct FinalAnalysisView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generadorReportes = GeneradorReportes()

    @State private var selectedTab: AnalysisSection = .timeline
    @State private var isDarkMode = true

    let contactoVisual: Int
    let muletillas: Int
    let textoUsuario: String
    let duracionSegundos: Int

    private var score: Int {
        max(0, min(100, contactoVisual - (muletillas * 3)))
    }

    private var levelText: String {
        switch score {
        case 85...100:
            "EXCELENTE"
        case 70...84:
            "BUENO"
        case 50...69:
            "MEJORABLE"
        default:
            "CRITICO"
        }
    }
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        scoreSection
                        segmentedSection
                        
                        if selectedTab == .timeline {
                            timelineCard
                        } else {
                            insightsCard
                        }
                        
                        retryButton
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
            
            floatingThemeButton
        }
        .task {
            guard generadorReportes.analisisGenerado == nil, generadorReportes.mensajeError == nil else { return }
            await generadorReportes.generarReporte(
                contactoVisual: contactoVisual,
                muletillas: muletillas,
                textoUsuario: textoUsuario,
                duracionSegundos: duracionSegundos
            )
        }
    }
}

extension FinalAnalysisView {
    
    private var backgroundView: some View {
        ZStack {
            (isDarkMode ? Color(red: 0.01, green: 0.05, blue: 0.14) : Color(red: 0.94, green: 0.97, blue: 1.0))
                .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    Color.cyan.opacity(isDarkMode ? 0.10 : 0.18),
                    .clear
                ],
                center: .top,
                startRadius: 80,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }
    
    private var headerSection: some View {
        HStack {
            CircleIconButton(systemName: "chevron.left") {
                dismiss()
            }
            
            Spacer()
            
            Text("Análisis Final")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(primaryTextColor)
            
            Spacer()
            
            CircleIconButton(systemName: "square.and.arrow.up") {
                // compartir
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var scoreSection: some View {
        CircularScoreView(
            score: score,
            label: levelText,
            isDarkMode: isDarkMode
        )
        .frame(height: 270)
    }
    
    private var segmentedSection: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Análisis de IA", section: .insights)
            segmentButton(title: "Línea de Tiempo", section: .timeline)
        }
        .padding(6)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    private func segmentButton(title: String, section: AnalysisSection) -> some View {
        let isSelected = selectedTab == section
        
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = section
            }
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .cyan : secondaryTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(isSelected ? Color.cyan.opacity(isDarkMode ? 0.18 : 0.12) : .clear)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var timelineCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.cyan)
                    .font(.system(size: 20))
                
                Text("Fluctuación del Score")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(primaryTextColor)
            }
            
            ScoreLineChartView(
                values: timelineValues,
                labels: timelineLabels,
                isDarkMode: isDarkMode
            )
            .frame(height: 220)
            
            VStack(spacing: 14) {
                ForEach(timelineEvents, id: \.time) { event in
                    TimelineRowView(
                        time: event.time,
                        title: event.title,
                        isDarkMode: isDarkMode
                    )
                }
            }
        }
        .padding(22)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    private var insightsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Insights de IA")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(primaryTextColor)

            if generadorReportes.estaGenerando {
                ProgressView()
                    .tint(.cyan)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else if let mensajeError = generadorReportes.mensajeError {
                InsightBulletView(
                    title: "Reporte no disponible",
                    description: mensajeError,
                    isDarkMode: isDarkMode
                )
            } else {
                ForEach(parsedInsights.indices, id: \.self) { index in
                    let insight = parsedInsights[index]
                    InsightBulletView(
                        title: insightTitle(for: index),
                        description: insight.description,
                        isDarkMode: isDarkMode
                    )
                }
            }
        }
        .padding(22)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    private var retryButton: some View {
        Button {
            // volver a practicar
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 22, weight: .semibold))
                
                Text("Practicar de Nuevo")
                    .font(.system(size: 20, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .background(
                LinearGradient(
                    colors: [
                        Color.cyan.opacity(0.85),
                        Color.blue
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color.cyan.opacity(0.22), radius: 18, y: 8)
        }
        .buttonStyle(.plain)
    }
    
    private var floatingThemeButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDarkMode.toggle()
                    }
                } label: {
                    Image(systemName: isDarkMode ? "sun.max" : "moon.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(isDarkMode ? .white.opacity(0.9) : .blue)
                        .frame(width: 76, height: 76)
                        .background(
                            Circle()
                                .fill(isDarkMode ? Color.white.opacity(0.10) : Color.white.opacity(0.8))
                        )
                        .overlay(
                            Circle()
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(.trailing, 18)
                .padding(.bottom, 150)
            }
        }
    }
    
    private var cardBackground: Color {
        isDarkMode ? Color.white.opacity(0.05) : Color.white.opacity(0.88)
    }
    
    private var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }
    
    private var primaryTextColor: Color {
        isDarkMode ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        isDarkMode ? .gray.opacity(0.9) : .gray
    }

    private var parsedInsights: [InsightItem] {
        let insightLines = generadorReportes.analisisGenerado?.insights ?? fallbackInsights
        return insightLines.map { line in
            InsightItem(description: line)
        }
    }

    private var fallbackInsights: [String] {
        [
            "Mantienes un contacto visual de \(contactoVisual)%, lo que da una buena base de presencia.",
            "Se detectaron \(muletillas) muletillas durante la sesión; conviene reducirlas para sonar más preciso.",
            "Refuerza tu cierre con frases más directas y pausas más controladas."
        ]
    }

    private var timelineValues: [CGFloat] {
        let puntos = generadorReportes.analisisGenerado?.timelineChart ?? fallbackTimelineChart
        return puntos.map { CGFloat($0.score) }
    }

    private var timelineLabels: [String] {
        let puntos = generadorReportes.analisisGenerado?.timelineChart ?? fallbackTimelineChart
        return puntos.map(\.time)
    }

    private var timelineEvents: [EventoTimelineIA] {
        generadorReportes.analisisGenerado?.timelineEvents ?? fallbackTimelineEvents
    }

    private func insightTitle(for index: Int) -> String {
        switch index {
        case 0:
            "Fortaleza principal"
        case 1:
            "Área crítica"
        default:
            "Consejo accionable"
        }
    }

    private var fallbackTimelineChart: [PuntoTimelineIA] {
        let times = timelineTimeMarks
        let scores = [
            max(35, score - 16),
            max(40, score - 10),
            score,
            max(30, score - 12),
            max(45, score - 6),
            score
        ]

        return zip(times, scores).map { time, score in
            PuntoTimelineIA(time: time, score: score)
        }
    }

    private var fallbackTimelineEvents: [EventoTimelineIA] {
        [
            EventoTimelineIA(time: "0:00", title: "Inicio con energía y objetivo claro"),
            EventoTimelineIA(time: timelineTimeMarks[2], title: muletillas > 4 ? "Se rompe el ritmo por muletillas" : "Mantienes buen ritmo argumental"),
            EventoTimelineIA(time: timelineTimeMarks[4], title: contactoVisual > 75 ? "Cierre con presencia visual sólida" : "Conviene reforzar el cierre y la mirada")
        ]
    }

    private var timelineTimeMarks: [String] {
        let total = max(duracionSegundos, 1)
        return (0..<6).map { index in
            let second = Int(round(Double(total) * Double(index) / 5.0))
            return formattedTime(second)
        }
    }

    private func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

enum AnalysisSection {
    case insights
    case timeline
}

private struct InsightItem {
    let description: String
}

#Preview {
    FinalAnalysisView(
        contactoVisual: 82,
        muletillas: 3,
        textoUsuario: "Quiero presentar una app que ayuda a practicar pitches con feedback en tiempo real.",
        duracionSegundos: 97
    )
}
