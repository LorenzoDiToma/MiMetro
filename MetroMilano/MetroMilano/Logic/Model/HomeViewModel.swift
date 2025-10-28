//
//  HomeViewModel.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import Foundation
import SwiftUI

// Struct per mappare i nomi del DB ai nomi da visualizzare
struct StationInfo: Identifiable, Hashable {
    let id = UUID()
    let dbName: String      // Nome ESATTO su Firebase (dal file stops.txt)
    let displayName: String // Nome "bello" da mostrare nell'app
}

// Struct MetroLine aggiornata per includere gli elenchi delle stazioni
struct MetroLine: Identifiable, Hashable {
    let id = UUID()
    let line: String         // "M1", "M2", ecc.
    let name: String         // "Linea 1", "Linea 2", ecc.
    let colorHex: String
    let destination: String  // Descrizione generale
    
    let dirA_Title: String           // Titolo per la Direzione A (es. "Sesto 1° Maggio")
    let dirA_doc_feriale: String     // ID documento Firestore feriale dir A
    let dirA_doc_festivo: String     // ID documento Firestore festivo dir A
    let stationsDirA: [StationInfo] // Elenco stazioni ordinate per la Direzione A
    
    let dirB_Title: String           // Titolo per la Direzione B (es. "Rho Fiera / Bisceglie")
    let dirB_doc_feriale: String     // ID documento Firestore feriale dir B
    let dirB_doc_festivo: String     // ID documento Firestore festivo dir B
    let stationsDirB: [StationInfo]
    
    func getLineColor() -> Color {
        switch colorHex {
        case "red": return .red
        case "green": return .green
        case "yellow": return .yellow
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }
}
    // ViewModel che contiene i dati statici delle linee e delle loro stazioni
    class HomeViewModel: ObservableObject {
        
        @Published var metroLines: [MetroLine] = [
            
            // --- M1 (Linea Rossa) ---
            MetroLine(
                line: "M1", name: "Linea 1", colorHex: "red",
                destination: "Sesto 1° Maggio ↔ Rho Fiera / Bisceglie",
                
                // Direzione A: Verso Sesto 1° Maggio FS
                dirA_Title: "Sesto 1° Maggio FS",
                dirA_doc_feriale: "m1_dir_sesto_feriale", // Assumendo che dir 0 sia Sesto
                dirA_doc_festivo: "m1_dir_sesto_festivo",
                stationsDirA: [
                    // Ramo Rho Fiera
                    StationInfo(dbName: "RHO FIERAMILANO", displayName: "Rho Fieramilano"),
                    StationInfo(dbName: "PERO", displayName: "Pero"),
                    StationInfo(dbName: "MOLINO DORINO", displayName: "Molino Dorino"),
                    StationInfo(dbName: "S.LEONARDO", displayName: "San Leonardo"),
                    StationInfo(dbName: "BONOLA", displayName: "Bonola"),
                    StationInfo(dbName: "URUGUAY", displayName: "Uruguay"),
                    StationInfo(dbName: "LAMPUGNANO", displayName: "Lampugnano"),
                    StationInfo(dbName: "QT8", displayName: "QT8"),
                    StationInfo(dbName: "LOTTO FIERAMILANOCITY", displayName: "Lotto"),
                    // Ramo Bisceglie
                    StationInfo(dbName: "BISCEGLIE", displayName: "Bisceglie"),
                    StationInfo(dbName: "INGANNI", displayName: "Inganni"),
                    StationInfo(dbName: "PRIMATICCIO", displayName: "Primaticcio"),
                    StationInfo(dbName: "BANDE NERE", displayName: "Bande Nere"),
                    StationInfo(dbName: "GAMBARA", displayName: "Gambara"),
                    StationInfo(dbName: "DE ANGELI", displayName: "De Angeli"),
                    StationInfo(dbName: "WAGNER", displayName: "Wagner"),
                    // Tronco Comune (dopo Pagano verso Sesto)
                    StationInfo(dbName: "PAGANO", displayName: "Pagano"),
                    StationInfo(dbName: "CONCILIAZIONE", displayName: "Conciliazione"),
                    StationInfo(dbName: "CADORNA FN M1", displayName: "Cadorna FN"),
                    StationInfo(dbName: "CAIROLI", displayName: "Cairoli"),
                    StationInfo(dbName: "CORDUSIO", displayName: "Cordusio"),
                    StationInfo(dbName: "DUOMO M1", displayName: "Duomo"),
                    StationInfo(dbName: "SAN BABILA", displayName: "San Babila"),
                    StationInfo(dbName: "PALESTRO", displayName: "Palestro"),
                    StationInfo(dbName: "P.TA VENEZIA", displayName: "Porta Venezia"),
                    StationInfo(dbName: "LIMA", displayName: "Lima"),
                    StationInfo(dbName: "LORETO M1", displayName: "Loreto"),
                    StationInfo(dbName: "PASTEUR", displayName: "Pasteur"),
                    StationInfo(dbName: "ROVERETO", displayName: "Rovereto"),
                    StationInfo(dbName: "TURRO", displayName: "Turro"),
                    StationInfo(dbName: "GORLA", displayName: "Gorla"),
                    StationInfo(dbName: "PRECOTTO", displayName: "Precotto"),
                    StationInfo(dbName: "VILLA S.G.", displayName: "Villa S.G."),
                    StationInfo(dbName: "SESTO MARELLI", displayName: "Sesto Marelli"),
                    StationInfo(dbName: "SESTO RONDO", displayName: "Sesto Rondò"),
                    StationInfo(dbName: "SESTO 1 MAGGIO FS", displayName: "Sesto 1° Maggio FS")
                ],
                
                // Direzione B: Verso Rho Fiera / Bisceglie
                dirB_Title: "Rho Fiera / Bisceglie",
                dirB_doc_feriale: "m1_dir_rho-bisceglie_feriale", // Assumendo che dir 1 sia Rho/Bisceglie
                dirB_doc_festivo: "m1_dir_rho-bisceglie_festivo",
                stationsDirB: [
                    // Da Sesto verso Pagano
                    StationInfo(dbName: "SESTO 1 MAGGIO FS", displayName: "Sesto 1° Maggio FS"),
                    StationInfo(dbName: "SESTO RONDO", displayName: "Sesto Rondò"),
                    StationInfo(dbName: "SESTO MARELLI", displayName: "Sesto Marelli"),
                    StationInfo(dbName: "VILLA S.G.", displayName: "Villa S.G."),
                    StationInfo(dbName: "PRECOTTO", displayName: "Precotto"),
                    StationInfo(dbName: "GORLA", displayName: "Gorla"),
                    StationInfo(dbName: "TURRO", displayName: "Turro"),
                    StationInfo(dbName: "ROVERETO", displayName: "Rovereto"),
                    StationInfo(dbName: "PASTEUR", displayName: "Pasteur"),
                    StationInfo(dbName: "LORETO M1", displayName: "Loreto"),
                    StationInfo(dbName: "LIMA", displayName: "Lima"),
                    StationInfo(dbName: "P.TA VENEZIA", displayName: "Porta Venezia"),
                    StationInfo(dbName: "PALESTRO", displayName: "Palestro"),
                    StationInfo(dbName: "SAN BABILA", displayName: "San Babila"),
                    StationInfo(dbName: "DUOMO M1", displayName: "Duomo"),
                    StationInfo(dbName: "CORDUSIO", displayName: "Cordusio"),
                    StationInfo(dbName: "CAIROLI", displayName: "Cairoli"),
                    StationInfo(dbName: "CADORNA FN M1", displayName: "Cadorna FN"),
                    StationInfo(dbName: "CONCILIAZIONE", displayName: "Conciliazione"),
                    StationInfo(dbName: "PAGANO", displayName: "Pagano"),
                    // Ramo Rho Fiera
                    StationInfo(dbName: "BUONARROTI", displayName: "Buonarroti"),
                    StationInfo(dbName: "AMENDOLA", displayName: "Amendola"),
                    StationInfo(dbName: "LOTTO FIERAMILANOCITY", displayName: "Lotto"),
                    StationInfo(dbName: "QT8", displayName: "QT8"),
                    StationInfo(dbName: "LAMPUGNANO", displayName: "Lampugnano"),
                    StationInfo(dbName: "URUGUAY", displayName: "Uruguay"),
                    StationInfo(dbName: "BONOLA", displayName: "Bonola"),
                    StationInfo(dbName: "S.LEONARDO", displayName: "San Leonardo"),
                    StationInfo(dbName: "MOLINO DORINO", displayName: "Molino Dorino"),
                    StationInfo(dbName: "PERO", displayName: "Pero"),
                    StationInfo(dbName: "RHO FIERAMILANO", displayName: "Rho Fieramilano"),
                    // Ramo Bisceglie
                    StationInfo(dbName: "WAGNER", displayName: "Wagner"),
                    StationInfo(dbName: "DE ANGELI", displayName: "De Angeli"),
                    StationInfo(dbName: "GAMBARA", displayName: "Gambara"),
                    StationInfo(dbName: "BANDE NERE", displayName: "Bande Nere"),
                    StationInfo(dbName: "PRIMATICCIO", displayName: "Primaticcio"),
                    StationInfo(dbName: "INGANNI", displayName: "Inganni"),
                    StationInfo(dbName: "BISCEGLIE", displayName: "Bisceglie")
                ]
            ),
            
            // --- M2 (Linea Verde) ---
            MetroLine(
                line: "M2", name: "Linea 2", colorHex: "green",
                destination: "Gessate / Cologno ↔ Abbiategrasso / Assago",
                // Direzione A: Verso Gessate / Cologno Nord
                dirA_Title: "Gessate / Cologno Nord",
                dirA_doc_feriale: "m2_dir_gessate_feriale", // Assumendo dir 0
                dirA_doc_festivo: "m2_dir_gessate_festivo",
                stationsDirA: [
                    // Ramo Assago
                    StationInfo(dbName: "ASSAGO MILANOFIORI FORUM", displayName: "Assago Forum"),
                    StationInfo(dbName: "ASSAGO MILANOFIORI NORD", displayName: "Assago Nord"),
                    // Ramo Abbiategrasso
                    StationInfo(dbName: "ABBIATEGRASSO", displayName: "Abbiategrasso"),
                    // Tronco Comune (da Famagosta verso C.na Gobba)
                    StationInfo(dbName: "FAMAGOSTA", displayName: "Famagosta"),
                    StationInfo(dbName: "ROMOLO", displayName: "Romolo"),
                    StationInfo(dbName: "P.TA GENOVA F.S.", displayName: "Porta Genova FS"),
                    StationInfo(dbName: "S.AGOSTINO", displayName: "Sant'Agostino"),
                    StationInfo(dbName: "S.AMBROGIO", displayName: "Sant'Ambrogio"),
                    StationInfo(dbName: "CADORNA FN M2", displayName: "Cadorna FN"),
                    StationInfo(dbName: "LANZA", displayName: "Lanza"),
                    StationInfo(dbName: "MOSCOVA", displayName: "Moscova"),
                    StationInfo(dbName: "GARIBALDI FS", displayName: "Garibaldi FS"),
                    StationInfo(dbName: "GIOIA", displayName: "Gioia"),
                    StationInfo(dbName: "CENTRALE FS", displayName: "Centrale FS"),
                    StationInfo(dbName: "CAIAZZO", displayName: "Caiazzo"),
                    StationInfo(dbName: "LORETO M2", displayName: "Loreto"),
                    StationInfo(dbName: "PIOLA", displayName: "Piola"),
                    StationInfo(dbName: "LAMBRATE FS", displayName: "Lambrate FS"),
                    StationInfo(dbName: "UDINE", displayName: "Udine"),
                    StationInfo(dbName: "CIMIANO", displayName: "Cimiano"),
                    StationInfo(dbName: "CRESCENZAGO", displayName: "Crescenzago"),
                    StationInfo(dbName: "CASCINA GOBBA", displayName: "Cascina Gobba"),
                    // Ramo Cologno Nord
                    StationInfo(dbName: "COLOGNO SUD", displayName: "Cologno Sud"),
                    StationInfo(dbName: "COLOGNO CENTRO", displayName: "Cologno Centro"),
                    StationInfo(dbName: "COLOGNO NORD", displayName: "Cologno Nord"),
                    // Ramo Gessate
                    StationInfo(dbName: "VIMODRONE", displayName: "Vimodrone"),
                    StationInfo(dbName: "CASCINA BURRONA", displayName: "Cascina Burrona"),
                    StationInfo(dbName: "CERNUSCO SUL NAVIGLIO", displayName: "Cernusco S/N"),
                    StationInfo(dbName: "VILLA FIORITA", displayName: "Villa Fiorita"),
                    StationInfo(dbName: "CASSINA DE PECCHI", displayName: "Cassina de' Pecchi"),
                    StationInfo(dbName: "BUSSERO", displayName: "Bussero"),
                    StationInfo(dbName: "VILLA POMPEA", displayName: "Villa Pompea"),
                    StationInfo(dbName: "GORGONZOLA", displayName: "Gorgonzola"),
                    StationInfo(dbName: "CASCINA ANTONIETTA", displayName: "Cascina Antonietta"),
                    StationInfo(dbName: "GESSATE", displayName: "Gessate")
                ],
                // Direzione B: Verso Abbiategrasso / Assago Forum
                dirB_Title: "Abbiategrasso / Assago Forum",
                dirB_doc_feriale: "m2_dir_assago_feriale", // Assumendo dir 1
                dirB_doc_festivo: "m2_dir_assago_festivo",
                stationsDirB: [
                    // Ramo Gessate
                    StationInfo(dbName: "GESSATE", displayName: "Gessate"),
                    StationInfo(dbName: "CASCINA ANTONIETTA", displayName: "Cascina Antonietta"),
                    StationInfo(dbName: "GORGONZOLA", displayName: "Gorgonzola"),
                    StationInfo(dbName: "VILLA POMPEA", displayName: "Villa Pompea"),
                    StationInfo(dbName: "BUSSERO", displayName: "Bussero"),
                    StationInfo(dbName: "CASSINA DE PECCHI", displayName: "Cassina de' Pecchi"),
                    StationInfo(dbName: "VILLA FIORITA", displayName: "Villa Fiorita"),
                    StationInfo(dbName: "CERNUSCO SUL NAVIGLIO", displayName: "Cernusco S/N"),
                    StationInfo(dbName: "CASCINA BURRONA", displayName: "Cascina Burrona"),
                    StationInfo(dbName: "VIMODRONE", displayName: "Vimodrone"),
                    // Ramo Cologno Nord
                    StationInfo(dbName: "COLOGNO NORD", displayName: "Cologno Nord"),
                    StationInfo(dbName: "COLOGNO CENTRO", displayName: "Cologno Centro"),
                    StationInfo(dbName: "COLOGNO SUD", displayName: "Cologno Sud"),
                    // Tronco Comune (da C.na Gobba verso Famagosta)
                    StationInfo(dbName: "CASCINA GOBBA", displayName: "Cascina Gobba"),
                    StationInfo(dbName: "CRESCENZAGO", displayName: "Crescenzago"),
                    StationInfo(dbName: "CIMIANO", displayName: "Cimiano"),
                    StationInfo(dbName: "UDINE", displayName: "Udine"),
                    StationInfo(dbName: "LAMBRATE FS", displayName: "Lambrate FS"),
                    StationInfo(dbName: "PIOLA", displayName: "Piola"),
                    StationInfo(dbName: "LORETO M2", displayName: "Loreto"),
                    StationInfo(dbName: "CAIAZZO", displayName: "Caiazzo"),
                    StationInfo(dbName: "CENTRALE FS", displayName: "Centrale FS"),
                    StationInfo(dbName: "GIOIA", displayName: "Gioia"),
                    StationInfo(dbName: "GARIBALDI FS", displayName: "Garibaldi FS"),
                    StationInfo(dbName: "MOSCOVA", displayName: "Moscova"),
                    StationInfo(dbName: "LANZA", displayName: "Lanza"),
                    StationInfo(dbName: "CADORNA FN M2", displayName: "Cadorna FN"),
                    StationInfo(dbName: "S.AMBROGIO", displayName: "Sant'Ambrogio"),
                    StationInfo(dbName: "S.AGOSTINO", displayName: "Sant'Agostino"),
                    StationInfo(dbName: "P.TA GENOVA F.S.", displayName: "Porta Genova FS"),
                    StationInfo(dbName: "ROMOLO", displayName: "Romolo"),
                    StationInfo(dbName: "FAMAGOSTA", displayName: "Famagosta"),
                    // Ramo Abbiategrasso
                    StationInfo(dbName: "ABBIATEGRASSO", displayName: "Abbiategrasso"),
                    // Ramo Assago
                    StationInfo(dbName: "ASSAGO MILANOFIORI NORD", displayName: "Assago Nord"),
                    StationInfo(dbName: "ASSAGO MILANOFIORI FORUM", displayName: "Assago Forum")
                ]
            ),
            
            // --- M3 (Linea Gialla) ---
            MetroLine(
                line: "M3", name: "Linea 3", colorHex: "yellow",
                destination: "San Donato ↔ Comasina",
                // Direzione A: Verso San Donato
                dirA_Title: "San Donato",
                dirA_doc_feriale: "m3_dir_sandonato_feriale", // Assumendo dir 0
                dirA_doc_festivo: "m3_dir_sandonato_festivo",
                stationsDirA: [ // !! CONTROLLA I NOMI ESATTI SU FIREBASE !!
                    StationInfo(dbName: "COMASINA", displayName: "Comasina"),
                    StationInfo(dbName: "AFFORI FN", displayName: "Affori FN"),
                    StationInfo(dbName: "AFFORI CENTRO", displayName: "Affori Centro"),
                    StationInfo(dbName: "DERGANO", displayName: "Dergano"),
                    StationInfo(dbName: "MACIACHINI", displayName: "Maciachini"),
                    StationInfo(dbName: "ZARA", displayName: "Zara"),
                    StationInfo(dbName: "SONDRIO", displayName: "Sondrio"),
                    StationInfo(dbName: "CENTRALE FS", displayName: "Centrale FS"),
                    StationInfo(dbName: "REPUBBLICA", displayName: "Repubblica"),
                    StationInfo(dbName: "TURATI", displayName: "Turati"),
                    StationInfo(dbName: "MONTENAPOLEONE", displayName: "Montenapoleone"),
                    StationInfo(dbName: "DUOMO M3", displayName: "Duomo"), // Nome corretto!
                    StationInfo(dbName: "MISSORI", displayName: "Missori"),
                    StationInfo(dbName: "CROCETTA", displayName: "Crocetta"),
                    StationInfo(dbName: "PORTA ROMANA", displayName: "Porta Romana"),
                    StationInfo(dbName: "LODI T.I.B.B.", displayName: "Lodi TIBB"),
                    StationInfo(dbName: "BRENTA", displayName: "Brenta"),
                    StationInfo(dbName: "CORVETTO", displayName: "Corvetto"),
                    StationInfo(dbName: "PORTO DI MARE", displayName: "Porto di Mare"),
                    StationInfo(dbName: "ROGOREDO FS", displayName: "Rogoredo FS"),
                    StationInfo(dbName: "SAN DONATO", displayName: "San Donato")
                              ],
                // Direzione B: Verso Comasina
                dirB_Title: "Comasina",
                dirB_doc_feriale: "m3_dir_comasina_feriale", // Assumendo dir 1
                dirB_doc_festivo: "m3_dir_comasina_festivo",
                stationsDirB: [ // !! CONTROLLA I NOMI ESATTI SU FIREBASE - ORDINE INVERSO !!
                    StationInfo(dbName: "SAN DONATO", displayName: "San Donato"),
                    StationInfo(dbName: "ROGOREDO FS", displayName: "Rogoredo FS"),
                    StationInfo(dbName: "PORTO DI MARE", displayName: "Porto di Mare"),
                    StationInfo(dbName: "CORVETTO", displayName: "Corvetto"),
                    StationInfo(dbName: "BRENTA", displayName: "Brenta"),
                    StationInfo(dbName: "LODI T.I.B.B.", displayName: "Lodi TIBB"),
                    StationInfo(dbName: "PORTA ROMANA", displayName: "Porta Romana"),
                    StationInfo(dbName: "CROCETTA", displayName: "Crocetta"),
                    StationInfo(dbName: "MISSORI", displayName: "Missori"),
                    StationInfo(dbName: "DUOMO M3", displayName: "Duomo"),
                    StationInfo(dbName: "MONTENAPOLEONE", displayName: "Montenapoleone"),
                    StationInfo(dbName: "TURATI", displayName: "Turati"),
                    StationInfo(dbName: "REPUBBLICA", displayName: "Repubblica"),
                    StationInfo(dbName: "CENTRALE FS", displayName: "Centrale FS"),
                    StationInfo(dbName: "SONDRIO", displayName: "Sondrio"),
                    StationInfo(dbName: "ZARA", displayName: "Zara"),
                    StationInfo(dbName: "MACIACHINI", displayName: "Maciachini"),
                    StationInfo(dbName: "DERGANO", displayName: "Dergano"),
                    StationInfo(dbName: "AFFORI CENTRO", displayName: "Affori Centro"),
                    StationInfo(dbName: "AFFORI FN", displayName: "Affori FN"),
                    StationInfo(dbName: "COMASINA", displayName: "Comasina")
                              ]
            ),
            
            // --- M4 (Linea Blu) ---
            MetroLine(
                line: "M4", name: "Linea 4", colorHex: "blue",
                destination: "Linate Aeroporto ↔ San Cristoforo",
                // Direzione A: Verso Linate Aeroporto
                dirA_Title: "Linate Aeroporto",
                dirA_doc_feriale: "m4_dir_linate_feriale", // Assumendo dir 0
                dirA_doc_festivo: "m4_dir_linate_festivo",
                stationsDirA: [ // !! CONTROLLA I NOMI ESATTI SU FIREBASE !!
                    StationInfo(dbName: "SAN CRISTOFORO", displayName: "San Cristoforo"),
                    // Aggiungi le altre fermate M4 qui...
                    StationInfo(dbName: "SEGNERI", displayName: "Segneri"),
                    StationInfo(dbName: "GELSOMINI", displayName: "Gelsomini"),
                    StationInfo(dbName: "FRATTINI", displayName: "Frattini"),
                    StationInfo(dbName: "TOLSTOJ", displayName: "Tolstoj"),
                    StationInfo(dbName: "BOLIVAR", displayName: "Bolivar"),
                    StationInfo(dbName: "CALIFORNIA", displayName: "California"),
                    StationInfo(dbName: "CONI ZUGNA", displayName: "Coni Zugna"),
                    StationInfo(dbName: "S.AMBROGIO", displayName: "Sant'Ambrogio"), // Potrebbe essere SAN AMBROGIO
                    StationInfo(dbName: "DE AMICIS", displayName: "De Amicis"),
                    StationInfo(dbName: "VETRA", displayName: "Vetra"),
                    StationInfo(dbName: "SANTA SOFIA", displayName: "Santa Sofia"),
                    StationInfo(dbName: "SFORZA-POLICLINICO", displayName: "Sforza Policlinico"),
                    StationInfo(dbName: "SAN BABILA", displayName: "San Babila"), // Già presente in M1
                    StationInfo(dbName: "TRICOLORE", displayName: "Tricolore"),
                    StationInfo(dbName: "DATEO", displayName: "Dateo"),
                    StationInfo(dbName: "SUSA", displayName: "Susa"),
                    StationInfo(dbName: "ARGONNE", displayName: "Argonne"),
                    StationInfo(dbName: "STAZIONE FORLANINI", displayName: "Forlanini FS"),
                    StationInfo(dbName: "REPETTI", displayName: "Repetti"),
                    StationInfo(dbName: "LINATE AEROPORTO", displayName: "Linate Aeroporto")
                              ],
                // Direzione B: Verso San Cristoforo
                dirB_Title: "San Cristoforo",
                dirB_doc_feriale: "m4_dir_sancristoforo_feriale", // Assumendo dir 1
                dirB_doc_festivo: "m4_dir_sancristoforo_festivo",
                stationsDirB: [ // !! CONTROLLA I NOMI ESATTI SU FIREBASE - ORDINE INVERSO !!
                    StationInfo(dbName: "LINATE AEROPORTO", displayName: "Linate Aeroporto"),
                    StationInfo(dbName: "REPETTI", displayName: "Repetti"),
                    StationInfo(dbName: "STAZIONE FORLANINI", displayName: "Forlanini FS"),
                    StationInfo(dbName: "ARGONNE", displayName: "Argonne"),
                    StationInfo(dbName: "SUSA", displayName: "Susa"),
                    StationInfo(dbName: "DATEO", displayName: "Dateo"),
                    StationInfo(dbName: "TRICOLORE", displayName: "Tricolore"),
                    StationInfo(dbName: "SAN BABILA", displayName: "San Babila"),
                    StationInfo(dbName: "SFORZA-POLICLINICO", displayName: "Sforza Policlinico"),
                    StationInfo(dbName: "SANTA SOFIA", displayName: "Santa Sofia"),
                    StationInfo(dbName: "VETRA", displayName: "Vetra"),
                    StationInfo(dbName: "DE AMICIS", displayName: "De Amicis"),
                    StationInfo(dbName: "S.AMBROGIO", displayName: "Sant'Ambrogio"), // Potrebbe essere SAN AMBROGIO
                    StationInfo(dbName: "CONI ZUGNA", displayName: "Coni Zugna"),
                    StationInfo(dbName: "CALIFORNIA", displayName: "California"),
                    StationInfo(dbName: "BOLIVAR", displayName: "Bolivar"),
                    StationInfo(dbName: "TOLSTOJ", displayName: "Tolstoj"),
                    StationInfo(dbName: "FRATTINI", displayName: "Frattini"),
                    StationInfo(dbName: "GELSOMINI", displayName: "Gelsomini"),
                    StationInfo(dbName: "SEGNERI", displayName: "Segneri"),
                    // Aggiungi le altre fermate M4 qui...
                    StationInfo(dbName: "SAN CRISTOFORO", displayName: "San Cristoforo")
                              ]
            ),
            
            // --- M5 (Linea Lilla) ---
            MetroLine(
                line: "M5", name: "Linea 5", colorHex: "purple",
                destination: "Bignami ↔ San Siro Stadio",
                // Direzione A: Verso Bignami
                dirA_Title: "Bignami",
                dirA_doc_feriale: "m5_dir_bignami_feriale", // Assumendo dir 0
                dirA_doc_festivo: "m5_dir_bignami_festivo",
                stationsDirA: [ // !! CONTROLLA I NOMI ESATTI SU FIREBASE !!
                    StationInfo(dbName: "SAN SIRO STADIO", displayName: "San Siro Stadio"),
                    StationInfo(dbName: "SAN SIRO IPPODROMO", displayName: "San Siro Ippodromo"),
                    StationInfo(dbName: "SEGESTA", displayName: "Segesta"),
                    StationInfo(dbName: "LOTTO M5", displayName: "Lotto"), // Potrebbe essere diverso da M1
                    StationInfo(dbName: "PORTELLO", displayName: "Portello"),
                    StationInfo(dbName: "TRE TORRI", displayName: "Tre Torri"),
                    StationInfo(dbName: "DOMODOSSOLA", displayName: "Domodossola FN"),
                    StationInfo(dbName: "GERUSALEMME", displayName: "Gerusalemme"),
                    StationInfo(dbName: "CENISIO", displayName: "Cenisio"),
                    StationInfo(dbName: "MONUMENTALE", displayName: "Monumentale"),
                    StationInfo(dbName: "GARIBALDI FS", displayName: "Garibaldi FS"), // Già presente in M2
                    StationInfo(dbName: "ISOLA", displayName: "Isola"),
                    StationInfo(dbName: "ZARA", displayName: "Zara"), // Già presente in M3
                    StationInfo(dbName: "MARCHE", displayName: "Marche"),
                    StationInfo(dbName: "ISTRIA", displayName: "Istria"),
                    StationInfo(dbName: "CA GRANDA", displayName: "Ca' Granda"),
                    StationInfo(dbName: "BICOCCA", displayName: "Bicocca"),
                    StationInfo(dbName: "PONALE", displayName: "Ponale"),
                    StationInfo(dbName: "BIGNAMI", displayName: "Bignami")
                              ],
                // Direzione B: Verso San Siro Stadio
                dirB_Title: "San Siro Stadio",
                dirB_doc_feriale: "m5_dir_sansiro_feriale", // Assumendo dir 1
                dirB_doc_festivo: "m5_dir_sansiro_festivo",
                stationsDirB: [ // !! CONTROLLA I NOMI ESATTI SU FIREBASE - ORDINE INVERSO !!
                    StationInfo(dbName: "BIGNAMI", displayName: "Bignami"),
                    StationInfo(dbName: "PONALE", displayName: "Ponale"),
                    StationInfo(dbName: "BICOCCA", displayName: "Bicocca"),
                    StationInfo(dbName: "CA GRANDA", displayName: "Ca' Granda"),
                    StationInfo(dbName: "ISTRIA", displayName: "Istria"),
                    StationInfo(dbName: "MARCHE", displayName: "Marche"),
                    StationInfo(dbName: "ZARA", displayName: "Zara"),
                    StationInfo(dbName: "ISOLA", displayName: "Isola"),
                    StationInfo(dbName: "GARIBALDI FS", displayName: "Garibaldi FS"),
                    StationInfo(dbName: "MONUMENTALE", displayName: "Monumentale"),
                    StationInfo(dbName: "CENISIO", displayName: "Cenisio"),
                    StationInfo(dbName: "GERUSALEMME", displayName: "Gerusalemme"),
                    StationInfo(dbName: "DOMODOSSOLA", displayName: "Domodossola FN"),
                    StationInfo(dbName: "TRE TORRI", displayName: "Tre Torri"),
                    StationInfo(dbName: "PORTELLO", displayName: "Portello"),
                    StationInfo(dbName: "LOTTO M5", displayName: "Lotto"),
                    StationInfo(dbName: "SEGESTA", displayName: "Segesta"),
                    StationInfo(dbName: "SAN SIRO IPPODROMO", displayName: "San Siro Ippodromo"),
                    StationInfo(dbName: "SAN SIRO STADIO", displayName: "San Siro Stadio")
                              ]
            )
        ]
    }
