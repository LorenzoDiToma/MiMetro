//
//  Favorites.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI
import FirebaseAuth

struct FavoritesView: View {
    
    // 1. Riceve i manager come parametri
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    
    // --- INIZIO CORREZIONE ---
    // 2. Aggiungi queste proprietà per accettare gli argomenti extra
    var onLogout: () -> Void
    var userEmail: String
    // --- FINE CORREZIONE ---

    var body: some View {
        NavigationStack {
            if favoritesManager.favoriteItems.isEmpty {
                Text("Non hai ancora aggiunto nessuna fermata ai preferiti.")
                    .foregroundStyle(.secondary)
                    .padding()
                    .navigationTitle("Preferiti")
                    // Aggiungo la toolbar anche qui per coerenza
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                ProfiloView(userEmail: userEmail, onLogout: onLogout)
                            } label: {
                                Image(systemName: "person.circle")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
            } else {
                List {
                    ForEach(favoritesManager.favoriteItems) { item in
                        // Cerca la linea e la direzione corrispondenti
                        if let (line, directionIndex) = findLineAndDirection(for: item) {
                            NavigationLink {
                                // Passa i manager alla vista Dettaglio
                                LineDetailView(
                                    line: line,
                                    initialDirection: directionIndex,
                                    authManager: authManager,
                                    favoritesManager: favoritesManager
                                )
                            } label: {
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(item.getLineColor())
                                        .font(.subheadline)
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.station_displayName)
                                            .font(.headline.weight(.medium))
                                        Text("\(item.line_name) - Dir: \(item.direction_title)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteFavorite) // Abilita swipe-to-delete
                }
                .navigationTitle("Preferiti")
                // Aggiungo la toolbar anche qui
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            ProfiloView(userEmail: userEmail, onLogout: onLogout)
                        } label: {
                            Image(systemName: "person.circle")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }

    private func deleteFavorite(at offsets: IndexSet) {
        guard let uid = authManager.user?.uid else { return }
        let itemsToRemove = offsets.map { favoritesManager.favoriteItems[$0] }
        for item in itemsToRemove {
            favoritesManager.removeFavorite(item: item, uid: uid)
        }
    }
    
    // Trova la MetroLine e la direzione da un FavoriteItem
    private func findLineAndDirection(for item: FavoriteItem) -> (MetroLine, Int)? {
        for line in homeViewModel.metroLines {
            if line.dirA_doc_feriale == item.doc_id_feriale {
                return (line, 0) // Direzione A
            }
            if line.dirB_doc_feriale == item.doc_id_feriale {
                return (line, 1) // Direzione B
            }
        }
        return nil
    }
}
