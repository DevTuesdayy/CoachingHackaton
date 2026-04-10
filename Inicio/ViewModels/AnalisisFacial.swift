//
//  AnalisisFacial.swift
//  Inicio
//
//  Created by Alan Cervantes on 08/04/26.
//

import Foundation
import ARKit
import Combine
import SwiftUI

class AnalisisFacial: NSObject, ObservableObject, ARSessionDelegate {
    
    @Published var contactoVisual: Int = 100
    @Published var estaMirandoCamara: Bool = true
    
    var arSession = ARSession()
    private var tareaSimulacion: Task<Void, Never>?
    
    func iniciarAnalisis() {
        #if targetEnvironment(simulator)
        print("Simulador, analisis facial falso")
        iniciarSimulacionVisual()
        return
        #else
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Este dispositivo no tiene camara TrueDepth(FaceID)")
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = false
        arSession.delegate = self
        arSession.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        #endif
    }
    
    func detenerAnalisis(){
        tareaSimulacion?.cancel()
        tareaSimulacion = nil
        
        #if !targetEnvironment(simulator)
        arSession.pause()
        #endif
    }
    
    private func iniciarSimulacionVisual() {
        tareaSimulacion = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                let scoreFalso = Int.random(in: 65...100)
                await MainActor.run {
                    self.contactoVisual = scoreFalso
                    self.estaMirandoCamara = scoreFalso > 70
                }
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]){
        guard let faceAnchor = anchors.compactMap({ $0 as? ARFaceAnchor}).first else { return }
        
        let blendShapes = faceAnchor.blendShapes
        let toleranciaPantalla: Float = 0.25

        let desvioArribaI = blendShapes[.eyeLookUpLeft]?.floatValue ?? 0
        let desvioAbajoI = blendShapes[.eyeLookDownLeft]?.floatValue ?? 0
        let desvioAbajoIAjustado = max(0, desvioAbajoI - toleranciaPantalla)
        let desvioAdentroI = blendShapes[.eyeLookInLeft]?.floatValue ?? 0
        let desvioAfueraI = blendShapes[.eyeLookOutLeft]?.floatValue ?? 0
        
        let desvioArribaD = blendShapes[.eyeLookUpRight]?.floatValue ?? 0
        let desvioAbajoD = blendShapes[.eyeLookDownRight]?.floatValue ?? 0
        let desvioAbajoDAjustado = max(0, desvioAbajoD - toleranciaPantalla)
        let desvioAdentroD = blendShapes[.eyeLookInRight]?.floatValue ?? 0
        let desvioAfueraD = blendShapes[.eyeLookOutRight]?.floatValue ?? 0
        
        let maxDesvioI = max(desvioArribaI, desvioAbajoIAjustado, desvioAdentroI, desvioAfueraI)
        let maxDesvioD = max(desvioArribaD, desvioAbajoDAjustado, desvioAdentroD, desvioAfueraD)
        
        let desvioPromedio = (maxDesvioI + maxDesvioD) / 2.0
        
        var scoreCrudo = 1.0 - (desvioPromedio * 2.5)
        scoreCrudo = max(0.0, min(1.0, scoreCrudo))
        let scoreFinal = Int(scoreCrudo * 100)
        
        DispatchQueue.main.async {
            self.contactoVisual = scoreFinal
            self.estaMirandoCamara = scoreFinal > 60
        }
    }
}


struct VistaCamaraAR: UIViewRepresentable {
    var session: ARSession
    
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.session = session
        view.contentMode = .scaleAspectFill
        return view
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
