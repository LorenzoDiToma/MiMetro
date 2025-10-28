import SwiftUI

struct HomeView: View {
    
    // 1. MODIFICA: Accetta i manager passati da MainTabView
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    
    // Queste le avevi già per la ProfiloView
    let onLogout: () -> Void
    let userEmail: String

    // 2. MODIFICA: Rimossa la creazione del ViewModel
    // @StateObject private var viewModel = HomeViewModel() // RIMOSSA

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        
                        // 3. MODIFICA: Usa homeViewModel
                        ForEach(homeViewModel.metroLines) { line in
                            Menu {
                                // --- Opzione 1: Link per Direzione A ---
                                NavigationLink {
                                    // 4. MODIFICA: Passa i manager
                                    LineDetailView(
                                        line: line,
                                        initialDirection: 0, // Passa 0 per Dir A
                                        authManager: authManager,
                                        favoritesManager: favoritesManager
                                    )
                                } label: {
                                    Label(line.dirA_Title, systemImage: "arrow.right.circle")
                                }

                                // --- Opzione 2: Link per Direzione B ---
                                NavigationLink {
                                    // 4. MODIFICA: Passa i manager
                                    LineDetailView(
                                        line: line,
                                        initialDirection: 1, // Passa 1 per Dir B
                                        authManager: authManager,
                                        favoritesManager: favoritesManager
                                    )
                                } label: {
                                    Label(line.dirB_Title, systemImage: "arrow.left.circle")
                                }

                            } label: {
                                // --- Etichetta del Menu: La nostra Card ---
                                MetroLineCard(
                                    line: line.line,
                                    // 4. MODIFICA: Usa la funzione helper per il colore
                                    color: line.getLineColor(),
                                    name: line.name,
                                    destination: line.destination
                                )
                                .contentShape(Rectangle())
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ProfiloView(userEmail: userEmail, onLogout: onLogout)
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// MetroLineCard rimane invariata
struct MetroLineCard: View {
    let line: String
    let color: Color
    let name: String
    let destination: String

    var body: some View {
        HStack(spacing: 16) {
            Text(line)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(destination)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// --- Anteprima per Xcode ---
//#Preview {
//    HomeView()
//}
