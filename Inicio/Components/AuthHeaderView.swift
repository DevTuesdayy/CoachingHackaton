//
//  AuthHeaderView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .blue.opacity(0.5), radius: 20)

                Image(systemName: "mic.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }

            Text("PitchCoach")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)

            Text("Tu espejo inteligente de comunicación")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AuthHeaderView()
    }
}
