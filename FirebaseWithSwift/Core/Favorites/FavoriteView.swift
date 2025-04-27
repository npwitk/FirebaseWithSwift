//
//  FavoriteView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 26/4/25.
//

import Combine
import SwiftUI


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
        .onFirstAppear(perform: viewModel.addListenerForFavorites)
    }
}



#Preview {
    NavigationStack {
        FavoriteView()
    }
}
 

