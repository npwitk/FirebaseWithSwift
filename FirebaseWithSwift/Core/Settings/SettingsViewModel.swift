//
//  SettingsViewModel.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 31/3/25.
//

import Foundation


@MainActor
@Observable
final class SettingsViewModel {
    
    var authProviders: [AuthProviderOption] = []
    var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let provider = try? AuthenticationManager.shared.getProviders() {
            authProviders = provider
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func resetPassword() async throws {
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "npcentreth@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Hello123!"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "npcentreth@gmail.com"
        let password = "Hello123!"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}
