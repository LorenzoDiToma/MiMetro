import SwiftUI

struct MainTabView: View {
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var themeManager: ThemeManager
    var onLogout: () -> Void
    var userEmail: String

    var body: some View {
        TabView {
            HomeView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                themeManager: themeManager,
                onLogout: onLogout,
                userEmail: userEmail
            )
            .tabItem {
                Label("Linee", systemImage: "list.bullet")
            }

            SearchView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                themeManager: themeManager
            )
            .tabItem {
                Label("Cerca", systemImage: "magnifyingglass")
            }

            FavoritesView(
                authManager: authManager,
                favoritesManager: favoritesManager,
                homeViewModel: homeViewModel,
                themeManager: themeManager,
                onLogout: onLogout,
                userEmail: userEmail
            )
            .tabItem {
                Label("Preferiti", systemImage: "star.fill")
            }
        }
        .accentColor(.red)
    }
}
