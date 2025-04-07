//
//  RootView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 22/3/25.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProductView()
//                    ProfileView(showSignInView: $showSignInView)
//                    SettingsView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    
    }
}

#Preview {
    RootView()
}
