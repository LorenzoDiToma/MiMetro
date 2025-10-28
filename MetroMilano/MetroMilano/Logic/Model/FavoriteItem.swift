//
//  FavoriteItem.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import Foundation
import SwiftUI

// Rappresenta un singolo preferito dell'utente.
// È 'Codable' per essere letto/scritto da Firestore.
struct FavoriteItem: Codable, Identifiable, Hashable {
    
    // Usiamo una combinazione come ID, perché un utente
    // potrebbe salvare "CADORNA" sia per M1 che per M2.
    var id: String { station_dbName + direction_title }
    
    let station_dbName: String      // Nome ESATTO su Firebase (es. "CADORNA FN M1")
    let station_displayName: String // Nome "bello" (es. "Cadorna FN")
    let line_name: String           // Nome della linea (es. "Linea 1")
    let line_color_hex: String      // Colore (es. "red", "green", ecc.)
    let direction_title: String     // Titolo della direzione (es. "Sesto 1° Maggio FS")
    
    // Documenti Firestore per ricaricare gli orari
    let doc_id_feriale: String
    let doc_id_festivo: String
    
    // Funzione helper per riconvertire la stringa in Colore
    func getLineColor() -> Color {
        switch line_color_hex {
        case "red": return .red
        case "green": return .green
        case "yellow": return .yellow
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }
}

// Estensione per convertire i nostri colori in stringhe (da salvare su DB)
extension Color {
    func toHex() -> String {
        switch self {
        case .red: return "red"
        case .green: return "green"
        case .yellow: return "yellow"
        case .blue: return "blue"
        case .purple: return "purple"
        default: return "gray"
        }
    }
}
