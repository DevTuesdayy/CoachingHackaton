//
//  ScoreLineChartView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct ScoreLineChartView: View {
    let values: [CGFloat]
    let labels: [String]
    let isDarkMode: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let maxValue = (values.max() ?? 1)
            let minValue = (values.min() ?? 0)
            let range = max(maxValue - minValue, 1)
            
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { _ in
                        Spacer()
                        Rectangle()
                            .fill((isDarkMode ? Color.white : Color.black).opacity(0.08))
                            .frame(height: 1)
                    }
                }
                
                Path { path in
                    for index in values.indices {
                        let x = width * CGFloat(index) / CGFloat(max(values.count - 1, 1))
                        let normalizedY = (values[index] - minValue) / range
                        let y = height - (normalizedY * (height - 40)) - 20
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.cyan, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                
                ForEach(values.indices, id: \.self) { index in
                    let x = width * CGFloat(index) / CGFloat(max(values.count - 1, 1))
                    let normalizedY = (values[index] - minValue) / range
                    let y = height - (normalizedY * (height - 40)) - 20
                    
                    Circle()
                        .fill(isDarkMode ? Color(red: 0.01, green: 0.05, blue: 0.14) : .white)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.cyan, lineWidth: 3)
                        )
                        .position(x: x, y: y)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        ForEach(labels, id: \.self) { label in
                            Text(label)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
}
