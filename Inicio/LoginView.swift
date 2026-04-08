//
//  LoginView.swift
//  Inicio
//
//  Created by ADMIN UNACH on 08/04/26.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            // Fondo con degradado radial oscuro
            RadialGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.2, blue: 0.4), Color.black]),
                           center: .top, startRadius: 100, endRadius: 900)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Logo y Header
                VStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
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
                
                // Formulario (Contenedor Glass)
                VStack(alignment: .leading, spacing: 20) {
                    
                    CustomInputField(label: "NOMBRE DE USUARIO", placeholder: "tu_usuario", icon: "person", text: $username)
                    
                    CustomInputField(label: "EMAIL", placeholder: "hola@ejemplo.com", icon: "envelope", text: $email)
                    
                    CustomInputField(label: "CONTRASEÑA", placeholder: "********", icon: "lock", text: $password, isSecure: true)
                    
                    // Botón Ingresar
                    Button(action: {
                        // Acción de login
                    }) {
                        HStack {
                            Text("Ingresar")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                
                // Footer
                HStack {
                    Text("¿Ya tienes una cuenta?")
                        .foregroundColor(.gray)
                    Button("Inicia Sesión") {
                        // Acción
                    }
                    .foregroundColor(.cyan)
                    .fontWeight(.bold)
                }
                .font(.footnote)
                
                Spacer()
            }
        }
    }
}

// Componente reutilizable para los campos de texto
struct CustomInputField: View {
    var label: String
    var placeholder: String
    var icon: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.5)))
                        .foregroundColor(.white)
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.5)))
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
