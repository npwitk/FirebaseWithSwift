//
//  SignInEmailView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 22/3/25.
//

import SwiftUI

@MainActor
@Observable
final class SignInEmailViewModel {
    var email = ""
    var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        
//        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
//        print("Success")
//        print(returnedUserData)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)

    }
}

struct SignInEmailView: View {
    
    @State private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
