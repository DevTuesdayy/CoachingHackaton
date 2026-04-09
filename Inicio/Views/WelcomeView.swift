//
//  WelcomeView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let loadingMessages = [
        "Analizando tu tono de voz...",
        "Calibrando métricas de confianza...",
        "Preparando el escenario virtual...",
        "Escuchando tus mejores ideas...",
        "Optimizando tu lenguaje corporal...",
        "¡Casi listo para tu pitch!"
    ]

    @State private var currentMessageIndex = 0
    @State private var opacity = 1.0

    var body: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 30) {
                HStack {
                    Spacer()

                    Button(action: themeManager.toggleTheme) {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(themeManager.primaryTextColor)
                            .frame(width: 48, height: 48)
                            .background(themeManager.elevatedCardColor)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(themeManager.borderColor, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()
                
                ZStack {
                    Circle()
                        .fill(themeManager.accentSecondaryColor.opacity(0.3))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                    
                    Circle()
                        .fill(themeManager.accentGradient)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "mic.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 8) {
                    Text("PitchCoach")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Potenciado por IA")
                        Image(systemName: "sparkles")
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.accentColor)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Text(loadingMessages[currentMessageIndex])
                        .font(.headline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .italic()
                        .opacity(opacity)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .onAppear {
                            startTextAnimation()
                        }
                }
                .frame(height: 100)

                NavigationLink {
                    RegisterView()
                } label: {
                    HStack(spacing: 12) {
                        Text("Comenzar")
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.accentGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func startTextAnimation() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                currentMessageIndex = (currentMessageIndex + 1) % loadingMessages.count
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = 1
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            .environmentObject(ThemeManager())
    }
}
