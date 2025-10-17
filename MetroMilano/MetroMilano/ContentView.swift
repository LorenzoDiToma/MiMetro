//
//  ContentView.swift
//  MetroMilano
//
//  Created by s16 on 07/10/25.
//

//git add .
//git commit -m "Messaggio del commit"
//git push origin main


import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 10) {
                Spacer()
                Image(systemName: "tram.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                Text("MetroMi")
                    .font(.title2)
                Spacer()
                VStack(spacing: 15){
                    NavigationLink(destination: LoginView()){
                        Text("Login")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    NavigationLink(destination: CreateAccountView()){
                            Text("Sign Up")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding()
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        }
        
    }
}

#Preview {
    ContentView()
}
