//
//  LineDetailView.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import SwiftUI
import Combine
import FirebaseFirestore // Assicurati di avere 'FirebaseFirestore' e 'FirebaseAuth' importati dove servono
import FirebaseAuth

// Assicurati che la struct 'StationInfo' sia definita SOLO in 'HomeViewModel.swift'
// e NON qui, per evitare l'errore 'Invalid redeclaration'.

struct LineDetailView: View {

    @StateObject private var viewModel = ScheduleViewModel()
    
    // --- 1. ACCESSO AI MANAGER GLOBALI ---
    // Questi manager devono essere passati da MetroMilanoOldApp.swift
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    // Parametri passati dalla vista precedente
    let line: MetroLine
    @State private var selectedDirectionIndex: Int
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    let maxLookaheadMinutes: Double = 10.0

    // Init per impostare la direzione iniziale
    init(line: MetroLine, initialDirection: Int = 0, authManager: AuthManager, favoritesManager: FavoritesManager) {
            self.line = line
            _selectedDirectionIndex = State(initialValue: initialDirection)
            self.authManager = authManager
            self.favoritesManager = favoritesManager
        }

    // Variabili Calcolate (per pulizia codice)
    private var currentDirectionTitle: String { selectedDirectionIndex == 0 ? line.dirA_Title : line.dirB_Title }
    private var currentStations: [StationInfo] { selectedDirectionIndex == 0 ? line.stationsDirA : line.stationsDirB }
    private var currentDocumentToFetch: String {
        let isFeriale = !Calendar.current.isDateInWeekend(Date())
        if selectedDirectionIndex == 0 { return isFeriale ? line.dirA_doc_feriale : line.dirA_doc_festivo }
        else { return isFeriale ? line.dirB_doc_feriale : line.dirB_doc_festivo }
    }

    // --- BODY DELLA VISTA ---
    var body: some View {
        VStack(spacing: 0) {
            // Picker (invariato)
            Picker("Direzione", selection: $selectedDirectionIndex) {
                Text(line.dirA_Title).tag(0)
                Text(line.dirB_Title).tag(1)
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .bottom])
            .background(Color(.systemGray6))
            .onChange(of: selectedDirectionIndex) { _ in fetchDataForCurrentSelection() }

            // Elenco fermate
            ScrollView {
                if viewModel.isLoading { ProgressView().padding(.top, 50) }
                else if viewModel.scheduleData.isEmpty && !viewModel.isLoading {
                     Text("Orari non disponibili al momento.").foregroundColor(.secondary).padding()
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        
                        ForEach(currentStations) { stationInfo in
                            
                            let arrivalInfo = calculateNextArrival(forDbName: stationInfo.dbName, now: currentTime)
                            let favoriteItem = createFavoriteItem(from: stationInfo)
                            let isFavorite = favoritesManager.isFavorite(item: favoriteItem)

                            HStack(spacing: 16) {
                                // Cerchio riempimento (invariato)
                                ArrivalCircleView(
                                    fillAmount: arrivalInfo.fillAmount,
                                    color: line.getLineColor()
                                )
                                .frame(width: 20, height: 20)

                                // Testo nome e minuti (invariato)
                                VStack(alignment: .leading) {
                                    Text(stationInfo.displayName)
                                        .font(.system(size: 18, weight: .bold))
                                    Text(arrivalInfo.displayText)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer() // Spinge la stella a destra

                                // --- 3. PULSANTE PREFERITI (STELLA) ---
                                Button {
                                    // Controlla di avere l'UID dell'utente
                                    guard let uid = authManager.user?.uid else { return }
                                    
                                    // Aggiunge o rimuove dal manager
                                    if isFavorite {
                                        favoritesManager.removeFavorite(item: favoriteItem, uid: uid)
                                    } else {
                                        favoritesManager.addFavorite(item: favoriteItem, uid: uid)
                                    }
                                } label: {
                                    Image(systemName: isFavorite ? "star.fill" : "star")
                                        .font(.title3)
                                        .foregroundColor(isFavorite ? .yellow : .gray.opacity(0.4))
                                }
                                .animation(.bouncy(duration: 0.3), value: isFavorite) // Piccola animazione
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(currentDirectionTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { fetchDataForCurrentSelection() } // Carica i dati la prima volta
        .onReceive(timer) { inputDate in currentTime = inputDate } // Aggiorna l'ora
    }

    // --- FUNZIONI LOGICHE ---

    // Chiede al ViewModel di scaricare i dati per il documento Firestore corretto
    private func fetchDataForCurrentSelection() {
        print("Richiesta dati per: \(currentDocumentToFetch)")
        viewModel.fetchSchedule(documentID: currentDocumentToFetch)
    }
    
    // Crea un oggetto FavoriteItem basato sullo stato attuale della vista
    private func createFavoriteItem(from station: StationInfo) -> FavoriteItem {
        return FavoriteItem(
            station_dbName: station.dbName,
            station_displayName: station.displayName,
            line_name: line.name,
            line_color_hex: line.colorHex, // Usa la funzione helper
            direction_title: currentDirectionTitle,
            // Scegli i doc ID giusti in base alla direzione selezionata
            doc_id_feriale: selectedDirectionIndex == 0 ? line.dirA_doc_feriale : line.dirB_doc_feriale,
            doc_id_festivo: selectedDirectionIndex == 0 ? line.dirA_doc_festivo : line.dirB_doc_festivo
        )
    }

    // Calcola l'orario (invariato)
    private func calculateNextArrival(forDbName dbStationName: String, now: Date) -> (displayText: String, fillAmount: CGFloat) {
        guard let stationTimes = viewModel.scheduleData[dbStationName] else {
            print("DBG: Dati non trovati per il dbName: '\(dbStationName)'")
            return ("N/D", 0.0)
        }
        return findNextTime(from: stationTimes, now: now, maxMinutes: maxLookaheadMinutes)
    }

    // Trova l'orario (invariato)
    private func findNextTime(from stationTimes: [String], now: Date, maxMinutes: Double) -> (displayText: String, fillAmount: CGFloat) {
        let calendar = Calendar.current
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let maxSeconds = maxMinutes * 60.0

        for timeString in stationTimes {
            guard let trainTime = timeFormatter.date(from: timeString) else { continue }
            guard let trainDate = calendar.date(
                bySettingHour: calendar.component(.hour, from: trainTime),
                minute: calendar.component(.minute, from: trainTime),
                second: calendar.component(.second, from: trainTime),
                of: now) else { continue }

            if trainDate >= now {
                let timeDifferenceSeconds = trainDate.timeIntervalSince(now)
                let progress = max(0.0, min(1.0, timeDifferenceSeconds / maxSeconds))
                let fillAmount = 1.0 - CGFloat(progress)
                let minutes = Int(timeDifferenceSeconds / 60)
                
                let displayText: String
                if minutes < 1 {
                    displayText = "In arrivo"
                } else if minutes == 1 {
                    displayText = "1 min"
                } else {
                    displayText = "\(minutes) min"
                }
                return (displayText, fillAmount)
            }
        }
        return ("Servizio terminato", 0.0)
    }
}

// --- VISTA PER IL CERCHIO (Invariata) ---
struct ArrivalCircleView: View {
    let fillAmount: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            Circle()
                .trim(from: 0, to: fillAmount)
                .stroke(color, lineWidth: 2)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: fillAmount)
        }
    }
}


