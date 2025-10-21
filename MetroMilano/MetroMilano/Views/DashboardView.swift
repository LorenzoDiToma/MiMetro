//
//  DashboardView.swift
//  MetroMilano
//
//  Created by s16 on 17/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        MetroLineCard(
                            line: "M1",
                            color: .red,
                            name: "Linea 1",
                            destination: "Sesto 1° Maggio ↔ Rho Fiera / Bisceglie",
                            status: "On Time",
                            statusColor: Color(UIColor.systemGreen)
                        )
                        
                        MetroLineCard(
                            line: "M2",
                            color: .green,
                            name: "Linea 2",
                            destination: "Abbiategrasso ↔ Cologno Nord",
                            status: "On Time",
                            statusColor: Color(UIColor.systemGreen)
                        )
                        
                        MetroLineCard(
                            line: "M3",
                            color: .yellow,
                            name: "Linea 3",
                            destination: "San Donato ↔ Comasina",
                            status: "Delayed",
                            statusColor: Color(UIColor.systemRed)
                        )
                        
                        MetroLineCard(
                            line: "M4",
                            color: .blue,
                            name: "Linea 4",
                            destination: "Linate Aeroporto ↔ San Babila",
                            status: "On Time",
                            statusColor: Color(UIColor.systemGreen)
                        )
                        
                        MetroLineCard(
                            line: "M5",
                            color: .purple,
                            name: "Linea 5",
                            destination: "Bignami ↔ San Siro Stadio",
                            status: "On Time",
                            statusColor: Color(UIColor.systemGreen)
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("") // Nessun titolo
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Azione finta, solo UI
                        print("Tasto profilo premuto")
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// --- COMPONENTE RIUTILIZZABILE PER LA CARD ---

struct MetroLineCard: View {
    let line: String
    let color: Color
    let name: String
    let destination: String
    let status: String
    let statusColor: Color

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
                
                Text(status)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor)
                    .cornerRadius(5)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

// --- Anteprima per Xcode ---
//#Preview {
//    HomeView()
//}
