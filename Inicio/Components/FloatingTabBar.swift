//
//  DashboardTab.swift
//  Inicio
//
//  Created by Emanuel Altuzar on 08/04/26.
//

import SwiftUI

struct FloatingTabBar: View {
    @EnvironmentObject private var themeManager: ThemeManager

    @Binding var selectedTab: DashboardTab

    private var barBackground: Color {
        themeManager.backgroundColor.opacity(themeManager.isDarkMode ? 0.96 : 0.92)
    }

    private var borderColor: Color {
        themeManager.borderColor
    }

    private var inactiveColor: Color {
        themeManager.iconMutedColor
    }

    var body: some View {
        HStack {
            tabButton(icon: "house.fill", label: "Inicio", tab: .home)
            Spacer()
            tabButton(icon: "chart.bar.fill", label: "Progreso", tab: .progress)
            Spacer()
            tabButton(icon: "creditcard.fill", label: "Pro", tab: .pro)
            Spacer()
            tabButton(icon: "person.fill", label: "Perfil", tab: .profile)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(barBackground)
        .overlay(
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(borderColor),
            alignment: .top
        )
    }

    @ViewBuilder
    private func tabButton(icon: String, label: String, tab: DashboardTab) -> some View {
        let isActive = selectedTab == tab

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 21, weight: .semibold))

                Text(label)
                    .font(.system(size: 11, weight: isActive ? .semibold : .regular))
            }
            .foregroundColor(isActive ? themeManager.accentColor : inactiveColor)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        VStack {
            Spacer()
            FloatingTabBar(selectedTab: .constant(.home))
        }
    }
    .environmentObject(ThemeManager())
}
