//
//  EntrenadorDeVoz.swift
//  Inicio
//
//  Created by Alan Cervantes on 08/04/26.
//


import SwiftUI
import Combine
import Speech
import AVFoundation

class EntrenadorDeVoz: ObservableObject {
    @Published var textoEscuchado = "Presiona iniciar y comienza a hablar..."
    @Published var contadorMuletillas = 0
    @Published var nivelVolumenActual: Double = 0
    @Published var volumenPromedio: Double = 0
    
    private var reconocedor = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
    private var solicitudReconocimiento: SFSpeechAudioBufferRecognitionRequest?
    private var tareaReconocimiento: SFSpeechRecognitionTask?
    private let motorDeAudio = AVAudioEngine()
    private var temporizadorSimulado: Timer?
    private var sumaVolumen: Double = 0
    private var muestrasVolumen: Int = 0
    private var muestrasVolumenActivas: Int = 0
    
    // lista de mulettilas
    private let muletillas = [
        "este", "eh", "bueno", "osea", "básicamente",
        "pues", "digamos", "tipo", "entonces", "digo",
        "literalmente", "obviamente", "mmm", "ah", "claro"
    ]
    
    func iniciarGrabacion() {
        detenerGrabacion()

        contadorMuletillas = 0
        textoEscuchado = "Escuchando..."
        nivelVolumenActual = 0
        volumenPromedio = 0
        sumaVolumen = 0
        muestrasVolumen = 0
        muestrasVolumenActivas = 0

        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil {
            iniciarSimulacion()
            return
        }

        let sesionDeAudio = AVAudioSession.sharedInstance()
        try? sesionDeAudio.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? sesionDeAudio.setActive(true, options: .notifyOthersOnDeactivation)

        //--------------
        
        let nodoEntrada = motorDeAudio.inputNode
        solicitudReconocimiento = SFSpeechAudioBufferRecognitionRequest()
        guard let solicitud = solicitudReconocimiento else { return }
        solicitud.shouldReportPartialResults = true
        solicitud.requiresOnDeviceRecognition = false
        
        
        tareaReconocimiento = reconocedor?.recognitionTask(with: solicitud) { resultado, error in
            if let resultado = resultado {
                let textoFinal = resultado.bestTranscription.formattedString
                
                DispatchQueue.main.async {
                    self.textoEscuchado = textoFinal
                    self.contarMuletillas(en: textoFinal)
                }
            }

            if error != nil || resultado?.isFinal == true {
                self.detenerGrabacion()
            }
        }
        
        let formatoGrabacion = nodoEntrada.inputFormat(forBus: 0)
        guard formatoGrabacion.sampleRate > 0, formatoGrabacion.channelCount > 0 else {
            textoEscuchado = "El formato del microfono no es valido."
            detenerGrabacion()
            return
        }

        nodoEntrada.removeTap(onBus: 0)
        nodoEntrada.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, _ in
            self.solicitudReconocimiento?.append(buffer)
            self.actualizarVolumen(with: buffer)
        }
        
        motorDeAudio.prepare()
        do {
            try motorDeAudio.start()
        } catch {
            textoEscuchado = "No se pudo iniciar la grabación."
            detenerGrabacion()
        }
    }
    
    func detenerGrabacion() {
        temporizadorSimulado?.invalidate()
        temporizadorSimulado = nil
        nivelVolumenActual = 0

        if motorDeAudio.isRunning {
            motorDeAudio.stop()
        }

        motorDeAudio.inputNode.removeTap(onBus: 0)
        solicitudReconocimiento?.endAudio()
        tareaReconocimiento?.cancel()
        tareaReconocimiento = nil
        solicitudReconocimiento = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func iniciarSimulacion() {
        let muestras = [
                    "Hola, este, quiero presentar mi idea de negocio para el hackathon.",
                    "Bueno, basicamente la app ayuda a los profesionales a practicar pitches.",
                    "Osea, te escucha en tiempo real y, pues, marca cada muletilla.",
                    "Eh, con esto digamos que puedes mejorar tu forma de hablar bajo presión.",
                    "Entonces, nuestro modelo de negocio es, mmm, un modelo freemium corporativo.",
                    "Literalmente puedes usarla sin internet, lo cual es una gran ventaja técnica.",
                    "Digo, actualmente pagar un coach es súper caro y poco accesible.",
                    "Ah, y la cámara analiza tu contacto visual, tipo, totalmente en vivo.",
                    "Pues, esperamos que les guste, este, nuestra propuesta de PitchCoach."
                ]

        var indice = 0
        textoEscuchado = muestras[0]
        contarMuletillas(en: muestras[0])
        let volumenesSimulados: [Double] = [0.22, 0.38, 0.31, 0.44, 0.57, 0.49, 0.63, 0.53, 0.41]
        registrarVolumen(volumenesSimulados[0])

        temporizadorSimulado = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            indice += 1
            guard indice < muestras.count else {
                timer.invalidate()
                self.temporizadorSimulado = nil
                return
            }

            self.textoEscuchado = muestras[0...indice].joined(separator: " ")
            self.contarMuletillas(en: self.textoEscuchado)
            self.registrarVolumen(volumenesSimulados[min(indice, volumenesSimulados.count - 1)])
        }
    }
    
    private func contarMuletillas(en texto: String) {
        let muletillasNormalizadas = Set(muletillas.map(normalizar))
        let palabras = texto
            .components(separatedBy: CharacterSet.letters.inverted)
            .map(normalizar)
            .filter { !$0.isEmpty }

        contadorMuletillas = palabras.filter { muletillasNormalizadas.contains($0) }.count
    }

    private func normalizar(_ texto: String) -> String {
        texto
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es-MX"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func actualizarVolumen(with buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData else { return }
        let frameLength = Int(buffer.frameLength)
        guard frameLength > 0 else { return }

        let samples = Array(UnsafeBufferPointer(start: channelData[0], count: frameLength))
        let rms = sqrt(samples.reduce(0) { $0 + Double($1 * $1) } / Double(frameLength))
        let peak = samples.reduce(0.0) { max($0, Double(abs($1))) }
        let safeRMS = max(rms, 0.000_01)
        let safePeak = max(peak, 0.000_01)
        let averagePower = 20 * log10(safeRMS)
        let peakPower = 20 * log10(safePeak)
        let blendedPower = (averagePower * 0.55) + (peakPower * 0.45)
        let minDb = -65.0
        let linearLevel = min(max((blendedPower - minDb) / abs(minDb), 0), 1)
        let boostedLevel = pow(linearLevel, 0.55)
        let normalizedLevel = min(max(boostedLevel * 1.18, 0), 1)

        DispatchQueue.main.async {
            self.registrarVolumen(normalizedLevel)
        }
    }

    private func registrarVolumen(_ nivel: Double) {
        nivelVolumenActual = (nivelVolumenActual * 0.25) + (nivel * 0.75)
        muestrasVolumen += 1

        if nivel > 0.04 {
            sumaVolumen += nivel
            muestrasVolumenActivas += 1
        }

        let divisor = max(muestrasVolumenActivas, 1)
        volumenPromedio = sumaVolumen / Double(divisor)
    }

    var intensidadVozDescripcion: String {
        switch volumenPromedio {
        case 0.82...:
            "Fuerte"
        case 0.55..<0.82:
            "Óptimo"
        case 0.28..<0.55:
            "Bajo"
        default:
            "Muy bajo"
        }
    }
}
