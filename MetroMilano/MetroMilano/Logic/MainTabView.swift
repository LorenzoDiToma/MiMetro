//
//  MainTabView.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI

struct MainTabView: View {
    
    // 1. I manager che già ricevi
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    
    // 2. AGGIUNGI QUESTE per accettare i parametri mancanti
    var onLogout: () -> Void
    var userEmail: String

    var body: some View {
        TabView {
            
            // --- Tab 1: Linee ---
            HomeView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                onLogout: onLogout,  // <-- PASSALO QUI
                userEmail: userEmail // <-- E QUI
            )
            .tabItem {
                Label("Linee", systemImage: "list.bullet")
            }
            
            // --- Tab 2: Cerca ---
            SearchView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel
            )
            .tabItem {
                Label("Cerca", systemImage: "magnifyingglass")
            }

            // --- Tab 3: Preferiti ---
            FavoritesView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                onLogout: onLogout,  // <-- PASSALO QUI
                userEmail: userEmail // <-- E QUI
            )
            .tabItem {
                Label("Preferiti", systemImage: "star.fill")
            }
        }
        .accentColor(.red) // Colore della tab selezionata
    }
}

