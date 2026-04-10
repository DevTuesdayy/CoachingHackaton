//
//  AnalisisFinalView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct FinalAnalysisView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var generadorReportes = GeneradorReportes()

    @State private var selectedTab: AnalysisSection = .timeline

    let idioma: IdiomaPractica
    let contactoVisual: Int
    let muletillas: Int
    let textoUsuario: String
    let duracionSegundos: Int
    let volumenPromedio: Double

    private var score: Int {
        ReporteSesion.calcularScore(
            contactoVisual: contactoVisual,
            muletillas: muletillas,
            duracionSegundos: duracionSegundos,
            volumenPromedio: volumenPromedio
        )
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
        }
        .task {
            guard generadorReportes.analisisGenerado == nil, generadorReportes.mensajeError == nil else { return }
            await generadorReportes.generarReporte(
                idioma: idioma,
                contactoVisual: contactoVisual,
                muletillas: muletillas,
                textoUsuario: textoUsuario,
                duracionSegundos: duracionSegundos,
                volumenPromedio: volumenPromedio
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension FinalAnalysisView {
    private var backgroundView: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    themeManager.accentColor.opacity(themeManager.isDarkMode ? 0.10 : 0.18),
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
            Text("Análisis Final")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(primaryTextColor)
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }

    private var scoreSection: some View {
        CircularScoreView(
            score: score,
            label: levelText
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
                .foregroundColor(isSelected ? themeManager.accentColor : secondaryTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(isSelected ? themeManager.accentColor.opacity(themeManager.isDarkMode ? 0.18 : 0.12) : .clear)
                )
        }
        .buttonStyle(.plain)
    }

    private var timelineCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(themeManager.accentColor)
                    .font(.system(size: 20))

                Text("Fluctuación del Score")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(primaryTextColor)
            }

            ScoreLineChartView(
                values: timelineValues,
                labels: timelineLabels
            )
            .frame(height: 220)

            VStack(spacing: 14) {
                ForEach(timelineEvents, id: \.time) { event in
                    TimelineRowView(
                        time: event.time,
                        title: event.title
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
                    .tint(themeManager.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else if let mensajeError = generadorReportes.mensajeError {
                InsightBulletView(
                    title: "Reporte no disponible",
                    description: mensajeError
                )
            } else {
                ForEach(parsedInsights.indices, id: \.self) { index in
                    let insight = parsedInsights[index]
                    InsightBulletView(
                        title: insightTitle(for: index),
                        description: insight.description
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
            dismiss()
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
            .background(themeManager.accentGradient)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: themeManager.accentColor.opacity(0.22), radius: 18, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var cardBackground: Color {
        themeManager.cardColor
    }

    private var borderColor: Color {
        themeManager.borderColor
    }

    private var primaryTextColor: Color {
        themeManager.primaryTextColor
    }

    private var secondaryTextColor: Color {
        themeManager.secondaryTextColor
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
            "Tu volumen promedio fue \(Int(volumenPromedio * 100))%, así que conviene mantener una proyección estable y clara."
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
            EventoTimelineIA(
                time: timelineTimeMarks[2],
                title: muletillas > 4 ? "Se rompe el ritmo por muletillas" : "Mantienes buen ritmo argumental"
            ),
            EventoTimelineIA(
                time: timelineTimeMarks[4],
                title: contactoVisual > 75 ? "Cierre con presencia visual sólida" : "Conviene reforzar el cierre y la mirada"
            )
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
        idioma: .espanol,
        contactoVisual: 82,
        muletillas: 3,
        textoUsuario: "Quiero presentar una app que ayuda a practicar pitches con feedback en tiempo real.",
        duracionSegundos: 97,
        volumenPromedio: 0.46
    )
    .environmentObject(ThemeManager())
}


//Enfoques vender y exponer
