import SwiftUI

struct ProfiloView: View {
    let userEmail: String
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
                Text(userEmail)
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

                CustomProfileButton(
                    title: "Settings",
                    iconName: "gearshape.fill",
                    buttonColor: .black,
                    destination: {SettingsView()}
                )

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(backgroundColor.ignoresSafeArea(.all, edges: .bottom))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

