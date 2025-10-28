//
//  Favorites.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI
import FirebaseAuth

struct FavoritesView: View {
    
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var themeManager: ThemeManager
    
    var onLogout: () -> Void
    var userEmail: String

    var body: some View {
        NavigationStack {
            if favoritesManager.favoriteItems.isEmpty {
                Text("Non hai ancora aggiunto nessuna fermata ai preferiti.")
                    .foregroundStyle(.secondary)
                    .padding()
                    .navigationTitle("Preferiti")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                ProfiloView(
                                    userEmail: userEmail,
                                    onLogout: onLogout,
                                    themeManager: themeManager
                                )
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
                        if let (line, directionIndex) = findLineAndDirection(for: item) {
                            NavigationLink {
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
                    .onDelete(perform: deleteFavorite)
                }
                .navigationTitle("Preferiti")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            ProfiloView(userEmail: userEmail, onLogout: onLogout, themeManager: themeManager)
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
