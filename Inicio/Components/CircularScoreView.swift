//
//  CircularScoreView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct CircularScoreView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let score: Int
    let label: String

    private var progress: CGFloat {
        min(max(CGFloat(score) / 100, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.borderColor.opacity(1.4),
                    lineWidth: 16
                )
                .frame(width: 230, height: 230)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    themeManager.accentGradient,
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 230, height: 230)
                .shadow(color: themeManager.accentColor.opacity(0.20), radius: 18)

            VStack(spacing: 6) {
                Text("\(score)")
                    .font(.system(size: 76, weight: .bold))
                    .foregroundColor(themeManager.primaryTextColor)

                Text(label)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(themeManager.accentColor)
                    .tracking(1.5)
            }
        }
    }
}
