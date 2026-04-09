//
//  StreakView.swift
//  Inicio
//
//  Created by Codex on 09/04/26.
//

import SwiftUI

struct StreakView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let streakDays: Int
    let recordDays: Int
    let confianza: Int
    let ritmoVoz: Int
    let contactoVisual: Int
    let onStartPractice: () -> Void

    private let weekLabels = ["L", "M", "X", "J", "V", "S", "D"]

    var body: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    headerSection
                    streakCard
                    mascotCard
                    progressSummarySection
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 120)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension StreakView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Tu Racha")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(themeManager.primaryTextColor)

            Text("Mantén tu compromiso diario")
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
        }
    }

    var streakCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.orange)
                        .frame(width: 64, height: 64)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(streakDays)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(themeManager.primaryTextColor)

                    Text("días consecutivos")
                        .font(.headline)
                        .foregroundColor(themeManager.secondaryTextColor)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("⭐ Récord: \(recordDays)")
                        .font(.headline)
                        .foregroundColor(Color.orange)

                    Text("🏆 EXPERTO")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(themeManager.warningColor)
                }
            }

            HStack(spacing: 10) {
                ForEach(weekLabels, id: \.self) { label in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(dayTileBackground(for: label))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(dayTileForeground(for: label))
                            )

                        Text(label)
                            .font(.caption.weight(.semibold))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(cardBackground)
        .overlay(cardBorder)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    var mascotCard: some View {
        VStack(spacing: 18) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.80, green: 0.25, blue: 0.26),
                            Color(red: 0.48, green: 0.77, blue: 0.66),
                            Color(red: 0.20, green: 0.52, blue: 0.72)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 146, height: 146)
                .overlay(
                    Circle()
                        .stroke(themeManager.accentSecondaryColor.opacity(0.45), lineWidth: 4)
                )
                .overlay(
                    Text("Paco 🦜")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.orange)
                        .clipShape(Capsule())
                        .offset(y: 74)
                )
                .padding(.bottom, 12)

            Text("¡Increíble trabajo! ¡Estás en fuego! 🔥")
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.primaryTextColor)

            Text("Tu dedicación está dando resultados")
                .font(.headline)
                .foregroundColor(themeManager.secondaryTextColor)

            Button(action: onStartPractice) {
                HStack(spacing: 10) {
                    Text("Iniciar Práctica")
                        .font(.headline.weight(.bold))
                    Image(systemName: "arrow.up.forward")
                        .font(.headline.weight(.bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color.yellow, Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(cardBackground)
        .overlay(cardBorder)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    var progressSummarySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Resumen de Progreso")
                .font(.title3.weight(.bold))
                .foregroundColor(themeManager.primaryTextColor)

            progressRow(
                icon: "heart",
                title: "Confianza",
                value: confianza,
                iconColor: Color(red: 0.99, green: 0.47, blue: 0.47),
                iconBackground: Color(red: 0.40, green: 0.18, blue: 0.24)
            )
            progressRow(
                icon: "speaker.wave.2",
                title: "Ritmo de Voz",
                value: ritmoVoz,
                iconColor: Color(red: 0.39, green: 0.62, blue: 1.0),
                iconBackground: Color(red: 0.14, green: 0.24, blue: 0.50)
            )
            progressRow(
                icon: "eye",
                title: "Contacto Visual",
                value: contactoVisual,
                iconColor: Color(red: 0.41, green: 0.90, blue: 0.47),
                iconBackground: Color(red: 0.12, green: 0.33, blue: 0.25)
            )

            adviceCard
        }
    }

    func progressRow(
        icon: String,
        title: String,
        value: Int,
        iconColor: Color,
        iconBackground: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(iconBackground)
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(themeManager.primaryTextColor)

                Spacer()

                Text("\(value)%")
                    .font(.title2.weight(.bold))
                    .foregroundColor(iconColor)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(themeManager.borderColor.opacity(1.5))
                        .frame(height: 10)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.yellow, Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(value) / 100, height: 10)
                }
            }
            .frame(height: 10)
        }
        .padding(18)
        .background(cardBackground)
        .overlay(cardBorder)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    var adviceCard: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(red: 0.14, green: 0.29, blue: 0.38))
                    .frame(width: 44, height: 44)

                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.accentColor)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Consejo del día")
                    .font(.title3.weight(.bold))
                    .foregroundColor(themeManager.primaryTextColor)

                Text("Practica frente al espejo para mejorar tu contacto visual. ¡La confianza se refleja en tu mirada!")
                    .font(.headline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(cardBackground)
        .overlay(cardBorder)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(themeManager.cardColor)
    }

    var cardBorder: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .stroke(themeManager.borderColor, lineWidth: 1)
    }

    func dayTileBackground(for label: String) -> Color {
        activeWeekLabels.contains(label) ? .orange : themeManager.elevatedCardColor
    }

    func dayTileForeground(for label: String) -> Color {
        activeWeekLabels.contains(label) ? .white : themeManager.secondaryTextColor
    }

    var activeWeekLabels: [String] {
        Array(weekLabels.prefix(min(streakDays, weekLabels.count)))
    }
}

#Preview {
    StreakView(
        streakDays: 7,
        recordDays: 12,
        confianza: 85,
        ritmoVoz: 78,
        contactoVisual: 92,
        onStartPractice: {}
    )
        .environmentObject(ThemeManager())
}
