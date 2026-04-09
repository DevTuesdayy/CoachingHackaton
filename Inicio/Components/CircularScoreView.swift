//
//  CircularScoreView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct CircularScoreView: View {
    let score: Int
    let label: String
    let isDarkMode: Bool
    
    private var progress: CGFloat {
        min(max(CGFloat(score) / 100, 0), 1)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.white.opacity(isDarkMode ? 0.10 : 0.12),
                    lineWidth: 16
                )
                .frame(width: 230, height: 230)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.cyan, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 230, height: 230)
                .shadow(color: .cyan.opacity(0.20), radius: 18)
            
            VStack(spacing: 6) {
                Text("\(score)")
                    .font(.system(size: 76, weight: .bold))
                    .foregroundColor(isDarkMode ? .white : .black)
                
                Text(label)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.cyan)
                    .tracking(1.5)
            }
        }
    }
}
