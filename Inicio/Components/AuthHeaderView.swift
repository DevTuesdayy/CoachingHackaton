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
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(themeManager.accentGradient.opacity(0.18))
                    .frame(width: 90, height: 90)
                    .shadow(color: themeManager.accentSecondaryColor.opacity(0.35), radius: 20)

                Image("icono")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 78, height: 78)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
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
