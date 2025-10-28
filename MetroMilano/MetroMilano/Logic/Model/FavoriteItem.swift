//
//  FavoriteItem.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import Foundation
import SwiftUI

struct FavoriteItem: Codable, Identifiable, Hashable {
    
    var id: String { station_dbName + direction_title }
    
    let station_dbName: String
    let station_displayName: String
    let line_name: String
    let line_color_hex: String
    let direction_title: String
    let doc_id_feriale: String
    let doc_id_festivo: String
    
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
