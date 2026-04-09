//
//  TabItems.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//


import SwiftUI

struct TabItem: View {
    var icon: String
    var label: String
    var active: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
            
            Text(label)
                .font(.system(size: 11))
        }
        .foregroundColor(active ? .cyan : .gray)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TabItem(icon: "house.fill", label: "Inicio", active: true)
    }
}
