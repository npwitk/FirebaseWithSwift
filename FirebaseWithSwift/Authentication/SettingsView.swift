//
//  SettingsView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 22/3/25.
//

import SwiftUI

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

struct SettingsView: View {
    
    @State private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            
            if viewModel.authUser?.isAnonymous == true {
                Section("Create Account") {
                    
                    Button("Link Google Account") {
                        Task {
                            do {
                                try await viewModel.linkGoogleAccount()
                                print("Goooooogle LINKED!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Link Apple Account") {
                        Task {
                            do {
                                try await viewModel.linkAppleAccount()
                                print("Apple LINKED!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Link Email Account") {
                        Task {
                            do {
                                try await viewModel.linkEmailAccount()
                                print("Email LINKED!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                }
            }
            
            
            if viewModel.authProviders.contains(.email) {
                Section("Modify your account") {
                    
                    Button("Reset password") {
                        Task {
                            do {
                                try await viewModel.resetPassword()
                                print("Password reset")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Update password") {
                        Task {
                            do {
                                try await viewModel.updatePassword()
                                print("Password updated!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Update email") {
                        Task {
                            do {
                                try await viewModel.updateEmail()
                                print("Email updated!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
