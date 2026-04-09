//
//  AuthHeaderView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct AuthHeaderView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(themeManager.accentGradient)
                    .frame(width: 80, height: 80)
                    .shadow(color: themeManager.accentSecondaryColor.opacity(0.5), radius: 20)

                Image(systemName: "mic.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }

            Text("PitchCoach")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(themeManager.primaryTextColor)

            Text("Tu espejo inteligente de comunicación")
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding(.top, 40)
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        AuthHeaderView()
    }
    .environmentObject(ThemeManager())
}
