//
//  TabbarView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 26/4/25.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            Tab("Product", systemImage: "cart") {
                NavigationStack {
                    ProductView()
                }
            }
            
            Tab("Favorites", systemImage: "star.fill") {
                NavigationStack {
                    FavoriteView()
                }
            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
