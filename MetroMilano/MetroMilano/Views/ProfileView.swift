import SwiftUI

struct ProfiloView: View {
    
    let onLogout: () -> Void
    
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.96)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 120, height: 120)
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.top, 100)
                
                // Nome Utente
                Text("Mario Rossi")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(height: 250)
                
                CustomProfileButton(
                    title: "Log Out",
                    iconName: "lock.slash.fill",
                    action: {
                        onLogout()
                    },
                    buttonColor: .red
                )
                
                // Pulsante Settings (Impostazioni)
                CustomProfileButton(
                    title: "Settings",
                    iconName: "gearshape.fill",
                    action: {
                        print("Vai alla schermata Impostazioni (Placeholder)")
                    },
                    buttonColor: .black
                )
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(backgroundColor.ignoresSafeArea(.all, edges: .bottom))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfiloView(onLogout: {
            print("Preview Logout")
        })
    }
}
