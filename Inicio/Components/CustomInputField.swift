//
//  CustomInputField.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

//
//  CustomInputField.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct CustomInputField: View {
    var label: String
    var placeholder: String
    var icon: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var disableAutocapitalization: Bool = false
    var disableAutocorrection: Bool = false
    
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
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder).foregroundColor(.gray.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(disableAutocapitalization ? .never : .sentences)
                    .autocorrectionDisabled(disableAutocorrection)
                } else {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder).foregroundColor(.gray.opacity(0.5))
                    )
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(disableAutocapitalization ? .never : .sentences)
                    .autocorrectionDisabled(disableAutocorrection)
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
