//
//  ProductView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 7/4/25.
//

import SwiftUI

@MainActor
@Observable
final class ProductViewModel {
    private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }

}

struct ProductView: View {
    @State private var viewModel = ProductViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllProducts()
        }
//            .onAppear {
//                viewModel.downloadProductsAndUploadToFirebase()
//            }
    }
}

#Preview {
    NavigationStack {
        ProductView()
    }
}
