//
//  ItemsView.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import SwiftUI

struct ItemsView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        NavigationView {
            List(viewModel.products) { product in
                HStack {
                    ProductImageView(url: product.productURL)
                    VStack(alignment: .leading) {
                        Text(product.productName)
                        Text("Uploaded: \(product.productTime.formatted())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(product.productStatus.rawValue)
                                                    .font(.caption)
                                                    .foregroundColor(product.productStatus == .available ? .green : .red)
                    }
                }
            }
            .onAppear{viewModel.fetchProducts()}
            .navigationBarTitle("Products")
        }.font(Font.custom("Maharlika-Regular",size:20)).navigationViewStyle(StackNavigationViewStyle())
            
    }

}

struct ProductImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: String

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
            }
        }
        .onAppear {
            imageLoader.loadImage(from: url)
        }
    }
}
