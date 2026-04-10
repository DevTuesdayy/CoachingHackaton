//
//  MainDashboardView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//

import SwiftData
import SwiftUI

struct MainDashboardView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    @StateObject private var entrenadorVoz = EntrenadorDeVoz()
    @State private var mostrarPracticaEnVivo = false
    @State private var reportePendiente: ReporteSesion?
    @State private var reporteSesion: ReporteSesion?
    @State private var selectedTab: DashboardTab = .home

    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = MainDashboardViewModel()

    var body: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                tabContent

                bottomTabBar
            }
        }
        .onAppear {
            viewModel.loadCurrentUser(context: context)
        }
        .fullScreenCover(
            isPresented: $mostrarPracticaEnVivo,
            onDismiss: presentarReportePendiente
        ) {
            VistaPracticaEnVivo(
                entrenadorVoz: entrenadorVoz,
                onFinalizarSesion: { reporte in
                    reportePendiente = reporte
                }
            )
        }
        .fullScreenCover(item: $reporteSesion) { reporte in
            FinalAnalysisView(
                idioma: reporte.idioma,
                contactoVisual: reporte.contactoVisual,
                muletillas: reporte.muletillas,
                textoUsuario: reporte.textoUsuario,
                duracionSegundos: reporte.duracionSegundos,
                volumenPromedio: reporte.volumenPromedio
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension MainDashboardView {
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    headerSection
                    practiceCardSection
                    statsSection
                    weeklyProgressSection
                }
                .padding(.bottom, 100)
            }

        case .streak:
            StreakView(
                streakDays: viewModel.rachaActual,
                recordDays: viewModel.mejorRacha,
                confianza: viewModel.confianzaResumen,
                ritmoVoz: viewModel.ritmoVozResumen,
                contactoVisual: viewModel.contactoVisualResumen
            ) {
                selectedTab = .home
                mostrarPracticaEnVivo = true
            }

        case .progress:
            ProgressView()

        case .profile:
            ProfileView()
        }
    }

    private var headerSection: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .foregroundColor(themeManager.iconMutedColor)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(themeManager.accentColor, lineWidth: 2)
                    )

                Circle()
                    .fill(themeManager.successColor)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle().stroke(themeManager.backgroundColor, lineWidth: 2)
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Hola, \(viewModel.username)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(themeManager.primaryTextColor)

                Text("Plan Pro • Activo")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.accentColor)
            }

            Spacer()

            streakButton
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private var streakButton: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .streak
                }
            } label: {
                Image(systemName: "flame")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.orange)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(themeManager.cardColor)
                    )
                    .overlay(
                        Circle()
                            .stroke(themeManager.borderColor, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            Text("\(viewModel.rachaActual)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.orange)
                .clipShape(Circle())
                .offset(x: 8, y: -8)
        }
    }

    private var practiceCardSection: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(themeManager.accentColor.opacity(0.1))
                    .frame(width: 70, height: 70)

                Image(systemName: "mic.fill")
                    .font(.system(size: 30))
                    .foregroundColor(themeManager.accentColor)
            }

            Text("Iniciar Práctica")
                .font(.title3)
                .bold()
                .foregroundColor(themeManager.primaryTextColor)

            Text("IA lista para analizar tu pitch")
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)

            languageSelector
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 35)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(themeManager.accentSecondaryColor.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.accentColor.opacity(0.8),
                                    themeManager.accentSecondaryColor.opacity(0.2),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .padding(.horizontal)
        .onTapGesture {
            mostrarPracticaEnVivo = true
        }
    }

    private var languageSelector: some View {
        HStack(spacing: 10) {
            ForEach(IdiomaPractica.allCases) { idioma in
                let isSelected = entrenadorVoz.idiomaSeleccionado == idioma

                Button {
                    entrenadorVoz.configurarIdioma(idioma)
                } label: {
                    Text(idioma.displayName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isSelected ? .white : themeManager.secondaryTextColor)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(
                            Capsule(style: .continuous)
                                .fill(isSelected ? themeManager.accentColor : themeManager.elevatedCardColor)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }

    private var statsSection: some View {
        HStack(spacing: 15) {
            StatCard(value: "\(viewModel.totalSesiones)", label: "SESIONES")
            StatCard(
                value: "\(viewModel.ultimoScorePromedio)",
                label: "SCORE PROMEDIO",
                unit: "/100",
                valueColor: themeManager.successColor
            )
        }
        .padding(.horizontal)
    }

    private var weeklyProgressSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Progreso Semanal")
                    .font(.headline)
                    .foregroundColor(themeManager.primaryTextColor)

                Spacer()

                Button("Ver todo >") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = .progress
                    }
                }
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.accentColor)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 38, height: 38)

                        Image(systemName: "bolt.fill")
                            .foregroundColor(themeManager.accentSecondaryColor)
                    }

                    VStack(alignment: .leading) {
                        Text("Fluidez verbal")
                            .foregroundColor(themeManager.primaryTextColor)
                            .fontWeight(.semibold)

                        Text("Has reducido tus muletillas un 15%")
                            .font(.caption)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }

                    Spacer()

                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(themeManager.successColor)
                        .padding(8)
                        .background(themeManager.successColor.opacity(0.1))
                        .clipShape(Circle())
                }

                BarChartView()
            }
            .padding(20)
            .background(themeManager.cardColor)
            .cornerRadius(25)
            .padding(.horizontal)
        }
    }

    private var bottomTabBar: some View {
        FloatingTabBar(selectedTab: $selectedTab)
    }

    private func presentarReportePendiente() {
        guard let reportePendiente else { return }
        Task {
            await viewModel.registrarSesion(reporte: reportePendiente, context: context)
        }
        reporteSesion = reportePendiente
        self.reportePendiente = nil
    }
}

#Preview {
    MainDashboardView()
        .environmentObject(ThemeManager())
}
