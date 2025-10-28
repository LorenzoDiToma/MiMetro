//
//  FavoritesManager.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FavoritesManager: ObservableObject {
    
    @Published var favoriteItems: [FavoriteItem] = []
    
    private let db = Firestore.firestore()
    
    func fetchFavorites(uid: String) {
        let userDocRef = db.collection("users").document(uid)
        
        userDocRef.getDocument { document, error in
            guard let document = document, document.exists else {
                print("Nessun documento preferiti trovato per l'utente \(uid)")
                return
            }
            
            if let favoritesData = document.data()?["favorites"] as? [[String: Any]] {
                
                self.favoriteItems = favoritesData.compactMap { data in
                    guard let dbName = data["station_dbName"] as? String,
                          let displayName = data["station_displayName"] as? String,
                          let lineName = data["line_name"] as? String,
                          let colorHex = data["line_color_hex"] as? String,
                          let dirTitle = data["direction_title"] as? String,
                          let docFeriale = data["doc_id_feriale"] as? String,
                          let docFestivo = data["doc_id_festivo"] as? String
                    else {
                        return nil
                    }
                    
                    return FavoriteItem(
                        station_dbName: dbName, station_displayName: displayName,
                        line_name: lineName, line_color_hex: colorHex,
                        direction_title: dirTitle, doc_id_feriale: docFeriale,
                        doc_id_festivo: docFestivo
                    )
                }
                print("Caricati \(self.favoriteItems.count) preferiti.")
            }
        }
    }
    
    func isFavorite(item: FavoriteItem) -> Bool {
        return favoriteItems.contains(where: { $0.id == item.id })
    }
    
    func addFavorite(item: FavoriteItem, uid: String) {
        favoriteItems.append(item)
        
        let userDocRef = db.collection("users").document(uid)
        userDocRef.setData([
            "favorites": FieldValue.arrayUnion([item.toFirestoreData()])
        ], merge: true) { error in
            if let error = error {
                print("Errore aggiunta preferito: \(error.localizedDescription)")
                self.favoriteItems.removeAll(where: { $0.id == item.id })
            } else {
                print("Preferito aggiunto con successo!")
            }
        }
    }
    
    func removeFavorite(item: FavoriteItem, uid: String) {
        favoriteItems.removeAll(where: { $0.id == item.id })
        
        let userDocRef = db.collection("users").document(uid)
        userDocRef.updateData([
            "favorites": FieldValue.arrayRemove([item.toFirestoreData()])
        ]) { error in
            if let error = error {
                print("Errore rimozione preferito: \(error.localizedDescription)")
                self.favoriteItems.append(item)
            } else {
                print("Preferito rimosso con successo!")
            }
        }
    }
    
    func clearFavorites() {
        favoriteItems = []
    }
}

extension FavoriteItem {
    func toFirestoreData() -> [String: Any] {
        return [
            "station_dbName": station_dbName,
            "station_displayName": station_displayName,
            "line_name": line_name,
            "line_color_hex": line_color_hex,
            "direction_title": direction_title,
            "doc_id_feriale": doc_id_feriale,
            "doc_id_festivo": doc_id_festivo
        ]
    }
}
