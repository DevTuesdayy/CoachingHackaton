//
//  ProfileView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            // Fondo oscuro consistente
            Color(red: 0.02, green: 0.05, blue: 0.12)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {

                    // --- HEADER CON SETTINGS ---
                    HStack {
                        Text("Mi Perfil")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // --- TARJETA DE PERFIL PRINCIPAL ---
                    VStack(spacing: 15) {
                        // Foto de Perfil con el icono de cámara
                        ZStack(alignment: .bottomTrailing) {
                            Image("user_profile")  // Asegúrate de tener una imagen en Assets o usa person.circle.fill
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.cyan, lineWidth: 2)
                                )

                            // Botón de editar foto
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                            .offset(x: 2, y: 2)
                        }

                        VStack(spacing: 4) {
                            Text("Sofia M.")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            Text("sofia@ejemplo.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        // Etiqueta Plan Pro con Gradiente
                        HStack(spacing: 8) {
                            Image(systemName: "creditcard.fill")
                                .font(.caption)
                            Text("Plan Pro")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30).stroke(
                            Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                    )
                    .padding(.horizontal)

                    // --- LISTA DE OPCIONES ---
                    VStack(spacing: 12) {
                        ProfileOptionRow(
                            icon: "mic.fill",
                            title: "Audio y Micrófono",
                            subtitle: "Dispositivos por defecto"
                        )
                        ProfileOptionRow(
                            icon: "camera.fill",
                            title: "Cámara y Video",
                            subtitle: "Preferencias de grabación"
                        )
                        ProfileOptionRow(
                            icon: "bell.fill",
                            title: "Notificaciones",
                            subtitle: "Alertas y recordatorios"
                        )
                        ProfileOptionRow(
                            icon: "creditcard.fill",
                            title: "Facturación",
                            subtitle: "Plan actual: Pro"
                        )
                        ProfileOptionRow(
                            icon: "shield.fill",
                            title: "Privacidad",
                            subtitle: "Tus datos"
                        )
                    }
                    .padding(.horizontal)

                    // --- BOTÓN CERRAR SESIÓN ---
                    Button(action: {
                        print("Cerrar sesión")
                    }) {
                        HStack {
                            Image(
                                systemName: "rectangle.portrait.and.arrow.right"
                            )
                            Text("Cerrar Sesión")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.red.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20).stroke(
                                Color.red.opacity(0.2),
                                lineWidth: 1
                            )
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom, 120)  // Espacio para el Tab Bar
            }
        }
    }
}

// MARK: - Componente de Fila de Opción
struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 15) {
            // Icono con fondo circular tenue
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 45, height: 45)
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.2))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.05))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25).stroke(
                Color.white.opacity(0.05),
                lineWidth: 1
            )
        )
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
