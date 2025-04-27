//
//  ProductView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 7/4/25.
//

import SwiftUI
import FirebaseFirestore

struct ProductView: View {
    @State private var viewModel = ProductViewModel()
    
    var body: some View {
        List {
            //            Button("FETCH MORE OBJECTS") {
            //                viewModel.getProductsByRating()
            //            }
            
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
//                    .contextMenu {
//                        Button("Add to favorites") {
//                            
//                        }
//                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        } label: {
                            Label("Add to favorite", systemImage: "star.fill")       
                        }
                        .tint(Color.orange)
                    }
                
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear {
                            print("PROGRESS VIEW APPEARED!")
                            
                            viewModel.getProducts()
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(filterOption.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductViewModel.CategoryOption.allCases, id: \.self) { categoryOption in
                        Button(categoryOption.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: categoryOption)
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.getProductsCount()
            viewModel.getProducts()
        }
        
        //        .task {
        //            try? await viewModel.getAllProducts()
        //        }
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
