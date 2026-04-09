//
//  BarChartView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct BarChartView: View {
    let heights: [CGFloat] = [0.3, 0.5, 0.4, 0.8, 0.6, 0.9, 0.7]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(heights.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .blue.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: heights[i] * 80)
            }
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        BarChartView()
            .padding()
    }
}
