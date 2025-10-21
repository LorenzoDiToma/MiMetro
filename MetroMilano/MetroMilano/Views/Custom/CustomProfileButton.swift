//
//  CustomProfileButton.swift
//  MetroMilano
//
//  Created by s16 on 21/10/25.
//

import SwiftUI

struct CustomProfileButton: View {
    
    let title: String
    let iconName: String
    let action: () -> Void
    let buttonColor: Color
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 30) // Per allineamento
                
                Text(title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(buttonColor)
            .foregroundColor(.white) // Testo bianco su sfondo nero/rosso
            .cornerRadius(12) // Angoli arrotondati come nel tuo tema
            .padding(.vertical, 5)
        }
    }
}
