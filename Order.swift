//
//  Order.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import FirebaseFirestore

enum OrderStatus: String {
    case completed = "Completed"
    case incompleted = "Incompleted"
}

struct Order: Identifiable {
    var id: String
    var userEmail: String  // User's email
    var checkoutName: String
    var checkoutNumber: String
    var items: [OrderItem]
    var orderStatus: OrderStatus
    var totalBill: String?  // Total bill computed from item prices
    var address: Address
    var orderTime: Date  // Order time

    init(id: String, data: [String: Any]) {
        self.id = id
        self.userEmail = data["userEmail"] as? String ?? "Unknown"
        self.checkoutName = data["checkoutName"] as? String ?? ""
        self.checkoutNumber = data["checkoutNumber"] as? String ?? ""
        self.orderStatus = OrderStatus(rawValue: data["orderStatus"] as? String ?? "") ?? .incompleted
        
        self.items = (data["items"] as? [[String: Any]] ?? []).map(OrderItem.init)
        
        // Calculate totalBill based on item prices
        let total = self.items.reduce(0.0) { sum, item in
            sum + (Double(item.productPrice) ?? 0.0)
        }
        self.totalBill = String(format: "%.2f", total)  // Convert total sum back to String
        
        if let addressData = data["address"] as? [String: Any] {
            self.address = Address(dictionary: addressData)
        } else {
            self.address = Address(dictionary: [:])
        }

        if let timestamp = data["orderTime"] as? Timestamp {
            self.orderTime = timestamp.dateValue()
        } else {
            self.orderTime = Date()
        }
    }

    var dictionaryRepresentation: [String: Any] {
        var orderDict: [String: Any] = [
            "userEmail": userEmail,
            "checkoutName": checkoutName,
            "checkoutNumber": checkoutNumber,
            "orderStatus": orderStatus.rawValue,
            "items": items.map { $0.dictionaryRepresentation },
            "address": address.dictionaryRepresentation,
            "orderTime": Timestamp(date: orderTime)
        ]
        
        if let totalBill = self.totalBill {
            orderDict["totalBill"] = totalBill
        }
        
        return orderDict
    }
}

// Assuming Address struct is defined elsewhere in your code and has a `dictionaryRepresentation` property or method.



struct OrderItem: Identifiable {
    let id: String  // Use the Firestore document ID or a unique identifier
    let productName: String
    let productPrice: String  // Assuming price is stored as a String
    let productURL: String

    // Initialize from a dictionary, typically from Firestore data
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString  // Generate a new UUID if no ID is provided
        self.productName = dictionary["productName"] as? String ?? ""
        self.productPrice = dictionary["productPrice"] as? String ?? "0"
        self.productURL = dictionary["productURL"] as? String ?? ""
    }

    var dictionaryRepresentation: [String: Any] {
        return [
            "id": id,
            "productName": productName,
            "productPrice": productPrice,
            "productURL": productURL
        ]
    }
}



