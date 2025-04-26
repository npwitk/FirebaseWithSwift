//
//  FavoriteView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 26/4/25.
//

import SwiftUI

@MainActor
@Observable
final class FavoriteViewModel {
    private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
            
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            getFavorites()
        }
    }
}

struct FavoriteView: View {
    @State private var viewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        } label: {
                            Label("Remove from favorite", systemImage: "trash")
                        }
                        
                    }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.getFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}
