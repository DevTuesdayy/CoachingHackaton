//
//  CustomInputField.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct CustomInputField: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var label: String
    var placeholder: String
    var icon: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var disableAutocapitalization: Bool = false
    var disableAutocorrection: Bool = false

    private var fieldBackground: Color {
        themeManager.fieldBackgroundColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.secondaryTextColor)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .frame(width: 20)

                if isSecure {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(
                                themeManager.secondaryTextColor.opacity(0.5)
                            )
                    )
                    .foregroundColor(themeManager.primaryTextColor)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(
                        disableAutocapitalization ? .never : .sentences
                    )
                    .autocorrectionDisabled(disableAutocorrection)
                } else {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(
                                themeManager.secondaryTextColor.opacity(0.5)
                            )
                    )
                    .foregroundColor(themeManager.primaryTextColor)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(
                        disableAutocapitalization ? .never : .sentences
                    )
                    .autocorrectionDisabled(disableAutocorrection)
                }
            }
            .padding()
            .background(fieldBackground)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(themeManager.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        CustomInputField(
            label: "EMAIL",
            placeholder: "hola@ejemplo.com",
            icon: "envelope",
            text: .constant("")
        )
        .padding()
    }
    .environmentObject(ThemeManager())
}
