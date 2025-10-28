//
//  SearchView.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI

struct SearchView: View {
    
    // 1. Riceve i manager come parametri
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    
    @State private var searchText = ""

    // Definiamo una struttura per i risultati di ricerca
    struct SearchableItem: Identifiable, Hashable {
        let id = UUID()
        let station: StationInfo
        let line: MetroLine
        let directionIndex: Int // 0 per DirA, 1 per DirB
        
        // --- INIZIO CORREZIONE ---
        // Aggiungi queste funzioni per conformarti a Equatable e Hashable
        
        static func == (lhs: SearchableItem, rhs: SearchableItem) -> Bool {
            // Due item sono uguali se stazione, linea E direzione sono identiche
            return lhs.station == rhs.station &&
                   lhs.line == rhs.line &&
                   lhs.directionIndex == rhs.directionIndex
        }
        
        func hash(into hasher: inout Hasher) {
            // Combina gli hash delle stesse proprietà usate per l'uguaglianza
            hasher.combine(station)
            hasher.combine(line)
            hasher.combine(directionIndex)
        }
        // --- FINE CORREZIONE ---
    }

    // Crea l'elenco di tutte le stazioni
    private var allStations: [SearchableItem] {
        var items = [SearchableItem]()
        for line in homeViewModel.metroLines {
            for station in line.stationsDirA {
                items.append(SearchableItem(station: station, line: line, directionIndex: 0))
            }
            for station in line.stationsDirB {
                items.append(SearchableItem(station: station, line: line, directionIndex: 1))
            }
        }
        // Questa riga ora funziona grazie alla correzione qui sopra
        return Array(Set(items)).sorted { $0.station.displayName < $1.station.displayName }
    }

    // Filtra l'elenco in base al testo
    private var filteredStations: [SearchableItem] {
        if searchText.isEmpty {
            return allStations
        } else {
            return allStations.filter {
                $0.station.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredStations) { item in
                NavigationLink {
                    // Assicurati che LineDetailView accetti questi manager
                    LineDetailView(
                        line: item.line,
                        initialDirection: item.directionIndex,
                        authManager: authManager,
                        favoritesManager: favoritesManager
                    )
                } label: {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(item.line.getLineColor()) // Usa helper
                            .font(.subheadline)
                        
                        VStack(alignment: .leading) {
                            Text(item.station.displayName)
                                .font(.headline.weight(.medium))
                            Text("\(item.line.name) - Dir: \(item.directionIndex == 0 ? item.line.dirA_Title : item.line.dirB_Title)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        // Pulsante Preferiti
                        let favoriteItem = createFavoriteItem(from: item)
                        let isFavorite = favoritesManager.isFavorite(item: favoriteItem)
                        
                        Button {
                            toggleFavorite(isFavorite: isFavorite, item: favoriteItem)
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(isFavorite ? .yellow : .gray.opacity(0.4))
                        }
                        .buttonStyle(PlainButtonStyle()) // Impedisce al link di attivarsi
                    }
                }
            }
            .navigationTitle("Cerca Fermata")
            .searchable(text: $searchText, prompt: "Scrivi un nome (es. Duomo)")
        }
    }
    
    // --- Funzioni Helper per i Preferiti ---
    
    private func createFavoriteItem(from item: SearchableItem) -> FavoriteItem {
        return FavoriteItem(
            station_dbName: item.station.dbName,
            station_displayName: item.station.displayName,
            line_name: item.line.name,
            line_color_hex: item.line.colorHex, // Usa la proprietà stringa
            direction_title: item.directionIndex == 0 ? item.line.dirA_Title : item.line.dirB_Title,
            doc_id_feriale: item.directionIndex == 0 ? item.line.dirA_doc_feriale : item.line.dirB_doc_feriale,
            doc_id_festivo: item.directionIndex == 0 ? item.line.dirA_doc_festivo : item.line.dirB_doc_festivo
        )
    }
    
    private func toggleFavorite(isFavorite: Bool, item: FavoriteItem) {
        guard let uid = authManager.user?.uid else { return }
        if isFavorite {
            favoritesManager.removeFavorite(item: item, uid: uid)
        } else {
            favoritesManager.addFavorite(item: item, uid: uid)
        }
    }
}
