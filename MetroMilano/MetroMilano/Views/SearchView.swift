//
//  SearchView.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var themeManager: ThemeManager
    
    @State private var searchText = ""

    struct SearchableItem: Identifiable, Hashable {
        let id = UUID()
        let station: StationInfo
        let line: MetroLine
        let directionIndex: Int
        
        
        static func == (lhs: SearchableItem, rhs: SearchableItem) -> Bool {
            return lhs.station == rhs.station &&
                   lhs.line == rhs.line &&
                   lhs.directionIndex == rhs.directionIndex
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(station)
            hasher.combine(line)
            hasher.combine(directionIndex)
        }
    }

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
        return Array(Set(items)).sorted { $0.station.displayName < $1.station.displayName }
    }

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
                    LineDetailView(
                        line: item.line,
                        initialDirection: item.directionIndex,
                        authManager: authManager,
                        favoritesManager: favoritesManager
                    )
                } label: {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(item.line.getLineColor())
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
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationTitle("Cerca Fermata")
            .searchable(text: $searchText, prompt: "Scrivi un nome (es. Duomo)")
        }
    }
    
    
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
