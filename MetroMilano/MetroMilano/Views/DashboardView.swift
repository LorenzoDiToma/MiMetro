import SwiftUI

struct HomeView: View {
    
    @ObservedObject var authManager: AuthManager
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var homeViewModel: HomeViewModel
    
    let onLogout: () -> Void
    let userEmail: String

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        
                        ForEach(homeViewModel.metroLines) { line in
                            Menu {
                                NavigationLink {
                                    LineDetailView(
                                        line: line,
                                        initialDirection: 0,
                                        authManager: authManager,
                                        favoritesManager: favoritesManager
                                    )
                                } label: {
                                    Label(line.dirA_Title, systemImage: "arrow.right.circle")
                                }

                                NavigationLink {
                                    LineDetailView(
                                        line: line,
                                        initialDirection: 1,
                                        authManager: authManager,
                                        favoritesManager: favoritesManager
                                    )
                                } label: {
                                    Label(line.dirB_Title, systemImage: "arrow.left.circle")
                                }

                            } label: {
                                MetroLineCard(
                                    line: line.line,
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

