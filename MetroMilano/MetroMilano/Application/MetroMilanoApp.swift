import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct MetroMilanoOldApp: App {
    
    @StateObject private var authManager = AuthManager()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var homeViewModel = HomeViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
            if authManager.user != nil {
                
                MainTabView(
                    authManager: authManager,
                    favoritesManager: favoritesManager,
                    homeViewModel: homeViewModel,
                    
                    // AGGIUNGI QUESTI DUE
                    onLogout: { authManager.signOut() },
                    userEmail: authManager.user?.email ?? "N/A"
                )
                .onAppear {
                    // Carichiamo i preferiti quando l'app (loggata) appare
                    if let uid = authManager.user?.uid {
                        favoritesManager.fetchFavorites(uid: uid)
                    }
                }
                
            } else {
                ContentView(authManager: authManager)
            }
        }
    }
}
