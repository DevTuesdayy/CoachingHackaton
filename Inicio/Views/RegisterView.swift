//
//  LoginView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = RegisterViewModel()
    @State private var goToDashboard = false
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack(spacing: 30) {
                AuthHeaderView()
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomInputField(
                        label: "NOMBRE DE USUARIO",
                        placeholder: "tu_usuario",
                        icon: "person",
                        text: $viewModel.username,
                        disableAutocapitalization: true,
                        disableAutocorrection: true
                    )
                    
                    CustomInputField(
                        label: "EMAIL",
                        placeholder: "hola@ejemplo.com",
                        icon: "envelope",
                        text: $viewModel.email,
                        keyboardType: .emailAddress,
                        disableAutocapitalization: true,
                        disableAutocorrection: true
                    )
                    
                    CustomInputField(
                        label: "CONTRASEÑA",
                        placeholder: "********",
                        icon: "lock",
                        text: $viewModel.password,
                        isSecure: true,
                        disableAutocapitalization: true,
                        disableAutocorrection: true
                    )
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    if !viewModel.successMessage.isEmpty {
                        Text(viewModel.successMessage)
                            .foregroundColor(.green)
                            .font(.footnote)
                    }
                    
                    Button {
                        viewModel.register(context: context)
                    } label: {
                        HStack {
                            Text("Registrarse")
                                .fontWeight(.bold)
                            Image(systemName: "person.badge.plus")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                    }
                    .padding(.top, 10)
                    
                    HStack {
                        Text("¿Ya tienes cuenta?")
                            .foregroundColor(.gray)
                        
                        NavigationLink("Inicia sesión") {
                            LoginView()
                        }
                        .foregroundColor(.cyan)
                        .fontWeight(.bold)
                    }
                    .font(.footnote)
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
                
                Spacer()
            }
        }
        .onChange(of: viewModel.successMessage) { _, newValue in
            if newValue == "Usuario registrado correctamente." {
                goToDashboard = true
            }
        }
        .navigationDestination(isPresented: $goToDashboard) {
            MainDashboardView()
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
