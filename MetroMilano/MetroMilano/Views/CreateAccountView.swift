//
//  CreateAccountView.swift
//  MetroMilano
//
//  Created by s16 on 17/10/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
struct CreateAccountView: View {
    @ObservedObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
        
    var body: some View{
        VStack(spacing: 16){
            
            Text("Crea il tuo account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 24)
            
            TextField("Email", text: $email)
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never) 
                            .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .textContentType(.newPassword)
            
            SecureField("Conferma password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .textContentType(.newPassword)
            
            Button(action: signUpUser){
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            
            Spacer()
            
            Text("By signing up, you agree to our Terms of Service.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom)
        }
        .padding()
        .navigationTitle("Create account")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
//-----------------------logica--------------------------------
    
    func showAlert(title: String, message: String) {
            alertTitle = title
            alertMessage = message
            showingAlert = true
        }
    
    func signUpUser(){
        
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else{
            showAlert(title: "Errore", message: "Per favore, compila tutti i campi.")
            return
        }
        
        guard password == confirmPassword else{
            showAlert(title: "Errore", message: "Le password non coincidono.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
                
            if let error = error{
                showAlert(title: "Errore di registrazione", message: error.localizedDescription)
            }else{
                print("Utente creato con successo: \(authResult?.user.uid ?? "ID non disponibile")")
                
                
                
            }
        }
        
    }
}


