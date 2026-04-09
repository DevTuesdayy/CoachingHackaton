//
//  ProfileView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//

//
//  ProfileView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    
                    HStack {
                        Text("Mi Perfil")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(themeManager.primaryTextColor)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    VStack(spacing: 15) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110)
                                .foregroundColor(themeManager.iconMutedColor)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(themeManager.accentColor, lineWidth: 2))
                            
                            ZStack {
                                Circle()
                                    .fill(themeManager.cardColor)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(themeManager.primaryTextColor)
                            }
                            .offset(x: 2, y: 2)
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.username)
                                .font(.title2)
                                .bold()
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            Text(viewModel.email)
                                .font(.subheadline)
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "creditcard.fill")
                                .font(.caption)
                            Text(viewModel.planName)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(themeManager.accentGradient)
                        .cornerRadius(20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(themeManager.cardColor)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(themeManager.borderColor, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ProfileOptionRow(icon: "mic.fill", title: "Audio y Micrófono", subtitle: "Dispositivos por defecto")
                        ProfileOptionRow(icon: "camera.fill", title: "Cámara y Video", subtitle: "Preferencias de grabación")
                        ProfileOptionRow(icon: "bell.fill", title: "Notificaciones", subtitle: "Alertas y recordatorios")
                        ProfileOptionRow(icon: "creditcard.fill", title: "Facturación", subtitle: "Plan actual: Pro")
                        ProfileOptionRow(icon: "shield.fill", title: "Privacidad", subtitle: "Tus datos")
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        print("Cerrar sesión")
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Cerrar Sesión")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(themeManager.dangerColor.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(themeManager.dangerColor.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(themeManager.dangerColor.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            viewModel.loadCurrentUser(context: context)
        }
    }
}

struct ProfileOptionRow: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(themeManager.elevatedCardColor)
                    .frame(width: 45, height: 45)
                Image(systemName: icon)
                    .foregroundColor(themeManager.iconMutedColor)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.primaryTextColor)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(themeManager.borderColor.opacity(2))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(themeManager.cardColor)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(themeManager.borderColor, lineWidth: 1)
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ThemeManager())
    }
}
