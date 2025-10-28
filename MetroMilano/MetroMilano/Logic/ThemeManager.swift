//
//  ThemeManager.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI
import Combine

enum ThemeOption: Int, CaseIterable, Identifiable {
    case system = 0
    case light = 1
    case dark = 2

    var id: Int { self.rawValue }

    var displayName: String {
        switch self {
        case .system: return "Automatico (Sistema)"
        case .light: return "Chiaro"
        case .dark: return "Scuro"
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var selectedTheme: ThemeOption = .system

    private let userDefaultsKey = "selectedTheme"

    init() {
        loadTheme()
    }

    func setTheme(_ theme: ThemeOption) {
        selectedTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: userDefaultsKey)
    }

    private func loadTheme() {
        let savedThemeRawValue = UserDefaults.standard.integer(forKey: userDefaultsKey)
        selectedTheme = ThemeOption(rawValue: savedThemeRawValue) ?? .system
    }

    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system:
            return nil 
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
