//
//  VistaPracticaEnVivo.swift
//  Inicio
//
//  Created by Alan Cervantes on 08/04/26.
//

import SwiftUI
import Speech

struct VistaPracticaEnVivo: View {
    @ObservedObject var entrenadorVoz: EntrenadorDeVoz
    @StateObject private var analisisFacial = AnalisisFacial()

    let onFinalizarSesion: (ReporteSesion) -> Void

    @Environment(\.presentationMode) var presentationMode

    @State private var estaGrabando = false
    @State private var fechaInicioSesion: Date?

    var body: some View {
        ZStack {
            #if targetEnvironment(simulator)
            Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()
            #else
            VistaCamaraAR(session: analisisFacial.arSession)
                .ignoresSafeArea()
            #endif
            
            VStack {
                HStack {
                    Text("🔴 EN VIVO")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.3))
                        .foregroundColor(.red)
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    Button(action: {
                        entrenadorVoz.detenerGrabacion()
                        analisisFacial.detenerAnalisis()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                Spacer()

                VStack(spacing: 15) {
                    
                    TarjetaFlotante(
                        icono: "exclamationmark.circle.fill",
                        colorIcono: entrenadorVoz.contadorMuletillas > 3 ? .red : .purple,
                        titulo: "MULETILLAS",
                        valor: "\(entrenadorVoz.contadorMuletillas) detectadas"
                    )
                    
                    TarjetaFlotante(
                        icono: analisisFacial.estaMirandoCamara ? "eye.fill" : "eye.slash.fill",
                        colorIcono: analisisFacial.estaMirandoCamara ? .cyan : .red,
                        titulo: "CONTACTO VISUAL",
                        valor: "\(analisisFacial.contactoVisual)"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                
                Spacer()
                
                ScrollView {
                    VStack {
                        Text(entrenadorVoz.textoEscuchado)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.cyan)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.never)
                .defaultScrollAnchor(.bottom)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(Color.cyan.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                Button(action: alternarGrabacion) {
                    ZStack {
                        Circle()
                            .stroke(Color.red.opacity(0.3), lineWidth: 4)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: estaGrabando ? 40 : 65, height: estaGrabando ? 40 : 65)
                            .cornerRadius(estaGrabando ? 10 : 32.5)
                            .animation(.spring(), value: estaGrabando)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            solicitarPermisos()
        }
    }
    
    private func alternarGrabacion() {
        if estaGrabando {
            finalizarSesion()
        } else {
            fechaInicioSesion = Date()
            entrenadorVoz.iniciarGrabacion()
            analisisFacial.iniciarAnalisis()
            estaGrabando = true
        }
    }

    private func finalizarSesion() {
        entrenadorVoz.detenerGrabacion()
        analisisFacial.detenerAnalisis()
        estaGrabando = false

        let reporte = ReporteSesion(
            contactoVisual: analisisFacial.contactoVisual,
            muletillas: entrenadorVoz.contadorMuletillas,
            textoUsuario: entrenadorVoz.textoEscuchado,
            duracionSegundos: duracionSesion
        )

        presentationMode.wrappedValue.dismiss()
        onFinalizarSesion(reporte)
    }

    private var duracionSesion: Int {
        guard let fechaInicioSesion else { return 0 }
        return max(1, Int(Date().timeIntervalSince(fechaInicioSesion)))
    }
    
    private func solicitarPermisos() {
        SFSpeechRecognizer.requestAuthorization { status in
        }
    }
}

struct TarjetaFlotante: View {
    var icono: String
    var colorIcono: Color
    var titulo: String
    var valor: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icono)
                .font(.title2)
                .foregroundColor(colorIcono)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                Text(valor)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.6))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    VistaPracticaEnVivo(
        entrenadorVoz: EntrenadorDeVoz(),
        onFinalizarSesion: { _ in }
    )
}
