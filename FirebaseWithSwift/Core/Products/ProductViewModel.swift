//
//  ProductViewModel.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 27/4/25.
//

import Foundation
import FirebaseFirestore

@MainActor
@Observable
final class ProductViewModel {
    private(set) var products: [Product] = []
    var selectedFilter: FilterOption? = nil
    var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
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
        self.products = []
        self.lastDocument = nil
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
        self.products = []
        self.lastDocument = nil
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
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getProductsCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductCount()
            print("ALL PRODUCT COUNT: \(count)")
        }
    }
    
    
    //    func getProductsByRating() {
    //        Task {
    ////            let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating) // But this approach could be a problem when you run into products with same ratings
    //
    //            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument)
    //            self.products.append(contentsOf: newProducts)
    //            self.lastDocument = lastDocument
    //        }
    //    }
    
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
}
