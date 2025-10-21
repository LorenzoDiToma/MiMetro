//
//  MetroMilanoApp.swift
//  MetroMilano
//
//  Created by s16 on 07/10/25.
//

import SwiftUI
import Firebase

@main
struct MetroMilanoApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            
            if authManager.user != nil {
                HomeView()
                    .environmentObject(authManager)
            }else {
                ContentView()
                    .environmentObject(authManager)
            }
            
        }
    }
}
