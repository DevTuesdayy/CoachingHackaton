//
//  InsightBulletView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 09/04/26.
//

import SwiftUI

struct InsightBulletView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(themeManager.primaryTextColor)
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(themeManager.elevatedCardColor)
        )
    }
}
