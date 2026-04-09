//
//  LoginView.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = LoginViewModel()
    @State private var goToDashboard = false
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack(spacing: 30) {
                AuthHeaderView()
                
                VStack(alignment: .leading, spacing: 20) {
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
                        viewModel.login(context: context)
                    } label: {
                        HStack {
                            Text("Ingresar")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
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
                        Text("¿No tienes cuenta?")
                            .foregroundColor(.gray)
                        
                        NavigationLink("Regístrate") {
                            RegisterView()
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
            if newValue == "Inicio de sesión correcto." {
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
        LoginView()
    }
}
