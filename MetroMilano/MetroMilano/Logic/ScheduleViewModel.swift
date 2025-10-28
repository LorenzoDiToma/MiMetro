//
//  ScheduleViewModel.swift
//  MetroMilano
//
//  Created by s16 on 28/10/25.
//

import Foundation
import FirebaseFirestore

typealias ScheduleData = [String: [String]]

class ScheduleViewModel: ObservableObject {
    
    @Published var scheduleData: ScheduleData = [:]
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    func fetchSchedule(documentID: String) {
                
        self.isLoading = true
        self.scheduleData = [:] // Svuota i dati vecchi
        
        let docRef = db.collection("orari").document(documentID)
        
        docRef.getDocument(as: ScheduleData.self) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let schedule):
                    self.scheduleData = schedule
                    print("Orari caricati con successo per \(documentID)")
                    
                case .failure(let error):
                    print("ERRORE: Impossibile scaricare o decodificare gli orari: \(error.localizedDescription)")
                }
            }
        }
    }
}
