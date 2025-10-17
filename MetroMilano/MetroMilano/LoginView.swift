//
//  LoginView.swift
//  MetroMilano
//
//  Created by s16 on 17/10/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View{
    
    @State private var email = ""
    @State private var password = ""
    
    //stato per gli avvisi
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 20){
            VStack(alignment: .leading, spacing: 4){
                Text("Bentornato")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Log in nel tuo account")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 60)
            .padding(.top, 20)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .textContentType(.password)
            
            Button(action: signInUser){
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            HStack(spacing: 4){
                Text("Non hai un account?")
                    .foregroundColor(.gray)
                
                NavigationLink("Sign Up", destination: CreateAccountView())
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .font(.footnote)
        }
        .padding()
        .navigationTitle("Milan Metro")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        }
    }
    
//--------------------------Logica---------------------------------------
    
    
    func showAlert(title: String, message: String) {
            alertTitle = title
            alertMessage = message
            showingAlert = true
        }
    
    func signInUser(){
        guard !email.isEmpty, !password.isEmpty else{
            showAlert(title: "Errore", message: "Per favore, inserisci email e password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){
            authResult, error in
            if let error = error {
                showAlert(title: "Errore di accesso", message: error.localizedDescription)
            }else{
                print("Utente connesso: \(authResult?.user.uid ?? "ID non disponibile")")
                showAlert(title: "Accesso riuscito", message: "Bentornato!")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
        }
    }
}
