//
//  SettingsView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 22/3/25.
//

import SwiftUI


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
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete Account")
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
