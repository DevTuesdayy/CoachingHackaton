//
//  TimelineRowView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct TimelineRowView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let time: String
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            Text(time)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundColor(themeManager.secondaryTextColor)
                .frame(width: 54, alignment: .leading)
            
            Circle()
                .fill(themeManager.accentColor)
                .frame(width: 14, height: 14)
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(themeManager.primaryTextColor)
            
            Spacer()
        }
    }
}
