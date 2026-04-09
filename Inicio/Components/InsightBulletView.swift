//
//  InsightBulletView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct InsightBulletView: View {
    let title: String
    let description: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(isDarkMode ? .white : .black)
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(isDarkMode ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        )
    }
}
