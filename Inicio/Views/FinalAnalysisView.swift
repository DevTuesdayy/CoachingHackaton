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

    @State private var selectedTab: AnalysisSection = .timeline

    let score: Int = 82
    let levelText: String = "EXCELENTE"

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
            label: levelText
        )
        .frame(height: 270)
    }
    
    private var segmentedSection: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Insights de IA", section: .insights)
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
                values: [56, 72, 65, 48, 76, 79],
                labels: ["0:00", "0:30", "1:00", "1:30", "2:00", "2:30"]
            )
            .frame(height: 220)
            
            VStack(spacing: 14) {
                TimelineRowView(time: "0:00", title: "Inicio")
                TimelineRowView(time: "1:00", title: "Contacto visual")
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
            
            InsightBulletView(
                title: "Buen cierre",
                description: "Terminaste con seguridad y mantuviste un ritmo estable al final."
            )
            
            InsightBulletView(
                title: "Mejora el contacto visual",
                description: "Hubo una caída cerca del minuto 1:30. Mantén la mirada al frente más tiempo."
            )
            
            InsightBulletView(
                title: "Fluidez sólida",
                description: "Tu discurso fue claro y con pocas muletillas en la segunda mitad."
            )
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
            .background(themeManager.accentGradient)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: themeManager.accentColor.opacity(0.22), radius: 18, y: 8)
        }
        .buttonStyle(.plain)
    }
    
    private var floatingThemeButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    themeManager.toggleTheme()
                } label: {
                    Image(systemName: themeManager.isDarkMode ? "sun.max" : "moon.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(themeManager.isDarkMode ? themeManager.primaryTextColor.opacity(0.9) : themeManager.accentSecondaryColor)
                        .frame(width: 76, height: 76)
                        .background(
                            Circle()
                                .fill(themeManager.elevatedCardColor)
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
}

enum AnalysisSection {
    case insights
    case timeline
}

#Preview {
    FinalAnalysisView()
        .environmentObject(ThemeManager())
}
