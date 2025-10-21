//
//  Untitled.swift
//  MetroMilano
//
//  Created by s16 on 21/10/25.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class AuthManager: ObservableObject{
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(){
        registerAuthStateHandler()
    }
    
    deinit{
        if let handle = handle{
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func registerAuthStateHandler(){
        handle = Auth.auth().addStateDidChangeListener{ [weak self] (auth, user) in
            self?.user = user
        }
    }
    
    public func singOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("Errore nel logout: \(error.localizedDescription)")
        }
    }
}
