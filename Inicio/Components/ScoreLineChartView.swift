//
//  ScoreLineChartView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct ScoreLineChartView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let values: [CGFloat]
    let labels: [String]

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let maxValue = (values.max() ?? 1)
            let minValue = (values.min() ?? 0)
            let hasVariation = maxValue != minValue
            let range = max(maxValue - minValue, 1)
            let horizontalPadding: CGFloat = 12
            let topPadding: CGFloat = 20
            let bottomPadding: CGFloat = 40
            let usableWidth = max(width - (horizontalPadding * 2), 1)
            let usableHeight = max(height - topPadding - bottomPadding, 1)
            
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { _ in
                        Spacer()
                        Rectangle()
                            .fill(themeManager.borderColor)
                            .frame(height: 1)
                    }
                }
                
                Path { path in
                    for index in values.indices {
                        let x = horizontalPadding + (usableWidth * CGFloat(index) / CGFloat(max(values.count - 1, 1)))
                        let normalizedY = hasVariation ? (values[index] - minValue) / range : 0.5
                        let y = topPadding + ((1 - normalizedY) * usableHeight)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(themeManager.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                
                ForEach(values.indices, id: \.self) { index in
                    let x = horizontalPadding + (usableWidth * CGFloat(index) / CGFloat(max(values.count - 1, 1)))
                    let normalizedY = hasVariation ? (values[index] - minValue) / range : 0.5
                    let y = topPadding + ((1 - normalizedY) * usableHeight)
                    
                    Circle()
                        .fill(themeManager.backgroundColor)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(themeManager.accentColor, lineWidth: 3)
                        )
                        .position(x: x, y: y)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        ForEach(labels, id: \.self) { label in
                            Text(label)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
}
