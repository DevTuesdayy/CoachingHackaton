//
//  MainDashboardView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//

import SwiftData
import SwiftUI

struct MainDashboardView: View {

    @StateObject private var entrenadorVoz = EntrenadorDeVoz()
    @State private var isDarkMode = true
    @State private var mostrarPracticaEnVivo = false
    @State private var reportePendiente: ReporteSesion?
    @State private var reporteSesion: ReporteSesion?
    @State private var selectedTab: DashboardTab = .home

    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = MainDashboardViewModel()

    private var backgroundColor: Color {
        isDarkMode
            ? Color(red: 0.02, green: 0.05, blue: 0.12)
            : Color(white: 0.95)
    }

    private var cardColor: Color {
        isDarkMode ? Color.white.opacity(0.05) : Color.white
    }

    private var textColor: Color {
        isDarkMode ? .white : .black
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        headerSection
                        practiceCardSection
                        statsSection
                        weeklyProgressSection
                    }
                    .padding(.bottom, 100)
                }

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
                contactoVisual: reporte.contactoVisual,
                muletillas: reporte.muletillas,
                textoUsuario: reporte.textoUsuario,
                duracionSegundos: reporte.duracionSegundos
            )
        }
    }
}

extension MainDashboardView {

    private var headerSection: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.cyan, lineWidth: 2)
                    )

                Circle()
                    .fill(Color.green)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle().stroke(backgroundColor, lineWidth: 2)
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Hola, \(viewModel.username)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(textColor)

                Text("Plan Pro • Activo")
                    .font(.system(size: 14))
                    .foregroundColor(.cyan)
            }

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    isDarkMode.toggle()
                }
            } label: {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 18))
                    .foregroundColor(isDarkMode ? .yellow : .blue)
                    .padding(12)
                    .background(cardColor)
                    .clipShape(Circle())
                    .shadow(
                        color: Color.black.opacity(isDarkMode ? 0 : 0.1),
                        radius: 5
                    )
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
 
    private var practiceCardSection: some View {
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
                .foregroundColor(textColor)

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
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .cyan.opacity(0.8),
                                    .blue.opacity(0.2),
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

    private var statsSection: some View {
        HStack(spacing: 15) {
            StatCard(value: "12", label: "SESIONES")
            StatCard(
                value: "85",
                label: "SCORE PROMEDIO",
                unit: "/100",
                valueColor: Color(red: 0.2, green: 0.9, blue: 0.5)
            )
        }
        .padding(.horizontal)
    }

    private var weeklyProgressSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Progreso Semanal")
                    .font(.headline)
                    .foregroundColor(textColor)

                Spacer()

                Button("Ver todo >") {}
                    .font(.system(size: 14))
                    .foregroundColor(.cyan)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 38, height: 38)

                        Image(systemName: "bolt.fill")
                            .foregroundColor(.purple)
                    }

                    VStack(alignment: .leading) {
                        Text("Fluidez verbal")
                            .foregroundColor(textColor)
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

                BarChartView()
            }
            .padding(20)
            .background(Color.white.opacity(0.05))
            .cornerRadius(25)
            .padding(.horizontal)
        }
    }

    private var bottomTabBar: some View {
        FloatingTabBar(selectedTab: $selectedTab, isDarkMode: isDarkMode)
    }

    private func presentarReportePendiente() {
        guard let reportePendiente else { return }
        reporteSesion = reportePendiente
        self.reportePendiente = nil
    }
}

#Preview {
    MainDashboardView()
}
