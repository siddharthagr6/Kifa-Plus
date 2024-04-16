//
//  Product.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Firebase

struct Product: Identifiable {
    var id: String
    var productName: String
    var productDescription: String
    var productGender: String
    var productMaterial: String
    var productPrice: Double
    var productSize: String
    var productType: String
    var productURL: String
    var productTime: Date
    var productStatus: ProductStatus
    
    init(from document: QueryDocumentSnapshot) {
            let data = document.data()
            self.id = document.documentID
            self.productName = data["productName"] as? String ?? ""
            self.productDescription = data["productDescription"] as? String ?? ""
            self.productGender = data["productGender"] as? String ?? ""
            self.productMaterial = data["productMaterial"] as? String ?? ""
            self.productPrice = data["productPrice"] as? Double ?? 0.0
            self.productSize = data["productSize"] as? String ?? ""
            self.productType = data["productType"] as? String ?? ""
            self.productURL = data["productURL"] as? String ?? ""
            self.productTime = (data["productTime"] as? Timestamp)?.dateValue() ?? Date()
            self.productStatus = ProductStatus(rawValue: data["productStatus"] as? String ?? "") ?? .available
        }
}

enum ProductStatus: String {
    case available = "Available"
    case unavailable = "Unavailable"
}
