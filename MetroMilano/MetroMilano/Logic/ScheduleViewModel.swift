//
//  ScheduleViewModel.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import Foundation
import FirebaseFirestore

// Definiamo un "alias" per i nostri dati
// Corrisponde a "NomeFermata": ["05:40:00", "05:47:00", ...]
typealias ScheduleData = [String: [String]]

class ScheduleViewModel: ObservableObject {
    
    // @Published notifica la nostra View quando i dati sono pronti
    @Published var scheduleData: ScheduleData = [:]
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    // Funzione per scaricare gli orari
    func fetchSchedule(documentID: String) {
        
        // Esempio di documentID: "m1_dir_sesto_feriale"
        
        self.isLoading = true
        self.scheduleData = [:] // Svuota i dati vecchi
        
        // 1. Prendi il riferimento al documento
        let docRef = db.collection("orari").document(documentID)
        
        // 2. Scarica il documento
        // .getDocument(as: ScheduleData.self) usa il nostro 'typealias'
        docRef.getDocument(as: ScheduleData.self) { result in
            // 3. Sposta il risultato sul thread principale per aggiornare l'UI
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let schedule):
                    // 4. Abbiamo i dati! Li salviamo.
                    self.scheduleData = schedule
                    print("Orari caricati con successo per \(documentID)")
                    
                case .failure(let error):
                    // 5. Gestisci l'errore
                    print("ERRORE: Impossibile scaricare o decodificare gli orari: \(error.localizedDescription)")
                    // Potrebbe essere un errore di connessione o un errore di battitura nel documentID
                }
            }
        }
    }
}
