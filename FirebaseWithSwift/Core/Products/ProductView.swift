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
    var selectedFilter: FilterOption? = nil
    var selectedCategory: CategoryOption? = nil
    
    //    func getAllProducts() async throws {
    //        self.products = try await ProductsManager.shared.getAllProducts()
    //    }
    //
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        
        self.selectedFilter = option
        self.getProducts()
        
        //        switch option {
        //        case .noFilter:
        //            self.products = try await ProductsManager.shared.getAllProducts()
        //        case .priceHigh:
        //            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
        //
        //            // UI
        //            // pricehigh
        //            break
        //        case .priceLow:
        //            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
        //
        //            break
        //        }
        
        
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case furniture
        case fragrances
        case groceries
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.getProducts()
        
        //        switch option {
        //        case .noCategory:
        //            self.products = try await ProductsManager.shared.getAllProducts()
        //        case .furniture, .fragrances, .groceries:
        //            self.products = try await ProductsManager.shared.getAllPorductsForCategory(category: option.rawValue)
        //        }
        
        
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey)
        }
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
