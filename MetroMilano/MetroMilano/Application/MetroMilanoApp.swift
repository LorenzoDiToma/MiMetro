import SwiftUI
import FirebaseCore

@main
struct MetroMilanoApp: App {

    @StateObject private var authManager = AuthManager()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var homeViewModel = HomeViewModel()
    
    @StateObject private var themeManager = ThemeManager() 
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authManager.user != nil {
                MainTabView(
                    authManager: authManager,
                    favoritesManager: favoritesManager,
                    homeViewModel: homeViewModel,
                    themeManager: themeManager,
                    onLogout: { authManager.signOut() },
                    userEmail: authManager.user?.email ?? "N/A"
                )
                .preferredColorScheme(themeManager.colorScheme)
                .onAppear {
                    if let uid = authManager.user?.uid {
                        favoritesManager.fetchFavorites(uid: uid)
                    }
                }
            } else {
                ContentView(authManager: authManager)
                    .preferredColorScheme(themeManager.colorScheme)
            }
        }
    }
}
