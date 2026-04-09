//
//  TimelineRowView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct TimelineRowView: View {
    let time: String
    let title: String
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            Text(time)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundColor(.gray)
                .frame(width: 54, alignment: .leading)
            
            Circle()
                .fill(Color.cyan)
                .frame(width: 14, height: 14)
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isDarkMode ? .white : .black)
            
            Spacer()
        }
    }
}
