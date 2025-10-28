//
//  MainTabView.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    
    var onLogout: () -> Void
    var userEmail: String

    var body: some View {
        TabView {
            
            HomeView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                onLogout: onLogout,
                userEmail: userEmail
            )
            .tabItem {
                Label("Linee", systemImage: "list.bullet")
            }
            
            SearchView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel
            )
            .tabItem {
                Label("Cerca", systemImage: "magnifyingglass")
            }

            FavoritesView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                onLogout: onLogout,
                userEmail: userEmail
            )
            .tabItem {
                Label("Preferiti", systemImage: "star.fill")
            }
        }
        .accentColor(.red) 
    }
}

