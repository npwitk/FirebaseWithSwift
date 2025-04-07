//
//  ProductCellView.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 7/4/25.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    var body: some View {
        HStack {
            
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)

            VStack(alignment: .leading) {
                Text(product.title ?? "n/a")
                    .foregroundStyle(.primary)
                    .bold()
                
                VStack(alignment: .leading) {
                    Text("Price: $" + String(product.price ?? 0))
                    Text("Rating: " + String(product.rating ?? 0))
                    Text("Category: " + (product.category ?? "n/a"))
                    Text("Brand: " + (product.brand ?? "n/a"))
                }
                .font(.callout)
                .foregroundStyle(.secondary)
            }
            
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "a", description: "a", price: 1.22, discountPercentage: nil, rating: 1.23, stock: 100, brand: "Apple", category: "Phone", thumbnail: nil, images: nil))
}
