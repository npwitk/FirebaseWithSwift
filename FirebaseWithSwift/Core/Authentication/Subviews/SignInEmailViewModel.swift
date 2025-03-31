//
//  SignInEmailViewModel.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 31/3/25.
//

import Foundation

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
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
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
