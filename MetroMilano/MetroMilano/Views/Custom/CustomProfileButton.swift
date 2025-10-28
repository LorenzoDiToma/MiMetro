import SwiftUI

struct CustomProfileButton<Destination: View>: View {
    let title: String
    let iconName: String
    let action: (() -> Void)?
    let buttonColor: Color

    @State private var isNavigationActive = false

    let destinationView: Destination?

    init(title: String, iconName: String, action: @escaping () -> Void, buttonColor: Color) where Destination == EmptyView {
        self.title = title
        self.iconName = iconName
        self.action = action
        self.buttonColor = buttonColor
        self.destinationView = nil
    }

    init(title: String, iconName: String, buttonColor: Color, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.iconName = iconName
        self.action = nil // Nessuna azione
        self.buttonColor = buttonColor
        self.destinationView = destination()
    }

    @ViewBuilder private var buttonContent: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .regular))
                .frame(width: 30)
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(buttonColor)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.vertical, 5)
    }

    var body: some View {
        Button(action: {
            if let action = action {
                action()
            } else if destinationView != nil {
                isNavigationActive = true
            }
        }) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
        .navigationDestination(isPresented: $isNavigationActive) {
            destinationView
        }
    }
}
