//
//  SettingsView 2.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section("Aspetto") {
                Picker("Tema App", selection: $themeManager.selectedTheme) {
                    ForEach(ThemeOption.allCases) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
                .onChange(of: themeManager.selectedTheme) { newTheme in
                    themeManager.setTheme(newTheme)
                }
            }
        }
        .navigationTitle("Impostazioni")
        .navigationBarTitleDisplayMode(.inline)

    }
}

