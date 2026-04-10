//
//  ProgressViewModel.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import Foundation
import SwiftData
import Combine

struct ScoreData: Identifiable {
    let id = UUID()
    let day: String
    let score: Int
}

struct Session: Identifiable {
    let id: PersistentIdentifier
    let title: String
    let date: String
    let duration: String
    let score: Int

    var scoreColorName: String {
        if score >= 85 { return "green" }
        if score >= 75 { return "yellow" }
        return "orange"
    }
}

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published var chartData: [ScoreData] = []
    @Published var sessions: [Session] = []
    @Published var mejorScore: Int = 0
    @Published var claridadPromedio: Int = 0

    func loadProgress(context: ModelContext) {
        guard let storedEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            reset()
            return
        }

        let currentEmail = normalized(storedEmail)

        do {
            let descriptor = FetchDescriptor<SesionPractica>(
                sortBy: [SortDescriptor(\.fecha, order: .reverse)]
            )
            let sesiones = try context.fetch(descriptor).filter {
                normalized($0.userEmail) == currentEmail
            }
            apply(sesiones)
        } catch {
            reset()
        }
    }

    private func apply(_ sesiones: [SesionPractica]) {
        mejorScore = sesiones.map(\.scorePromedio).max() ?? 0

        if sesiones.isEmpty {
            claridadPromedio = 0
            sessions = []
            chartData = weeklyEmptyChart()
            return
        }

        claridadPromedio = Int(
            round(
                sesiones.map { Double($0.contactoVisual) }.reduce(0, +) / Double(sesiones.count)
            )
        )

        sessions = sesiones.map { sesion in
            Session(
                id: sesion.persistentModelID,
                title: sesion.temaPrincipal,
                date: formattedDate(sesion.fecha),
                duration: formattedDuration(seconds: sesion.duracionSegundos),
                score: sesion.scorePromedio
            )
        }

        chartData = weeklyChart(from: sesiones)
    }

    private func reset() {
        mejorScore = 0
        claridadPromedio = 0
        sessions = []
        chartData = weeklyEmptyChart()
    }

    private func weeklyChart(from sesiones: [SesionPractica]) -> [ScoreData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "E"

        return (0..<7).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: -(6 - offset), to: today) else { return nil }
            let sameDaySessions = sesiones.filter { calendar.isDate($0.fecha, inSameDayAs: day) }
            let averageScore = sameDaySessions.isEmpty
                ? 0
                : Int(round(Double(sameDaySessions.map(\.scorePromedio).reduce(0, +)) / Double(sameDaySessions.count)))

            return ScoreData(
                day: formatter.string(from: day).capitalized.replacingOccurrences(of: ".", with: ""),
                score: averageScore
            )
        }
    }

    private func weeklyEmptyChart() -> [ScoreData] {
        ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"].map {
            ScoreData(day: $0, score: 0)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.unitsStyle = .short

        if Calendar.current.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "es_MX")
            timeFormatter.timeStyle = .short
            return "Hoy, \(timeFormatter.string(from: date))"
        }

        if Calendar.current.isDateInYesterday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "es_MX")
            timeFormatter.timeStyle = .short
            return "Ayer, \(timeFormatter.string(from: date))"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "EEE, HH:mm"
        return dateFormatter.string(from: date).capitalized
    }

    private func formattedDuration(seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func normalized(_ email: String) -> String {
        email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
