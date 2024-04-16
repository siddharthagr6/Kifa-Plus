//
//  CompletedOrder.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import SwiftUI
import Firebase

struct CompletedOrder {
    var orderTime: Date
    var orderName: String  // Assuming this is the name of the order or a summary
    var orderText: String  // A message or additional info about the order
    var orderPrice: String  // The total price of the order

    var dictionaryRepresentation: [String: Any] {
        return [
            "orderTime": Timestamp(date: orderTime),
            "orderName": orderName,
            "orderText": orderText,
            "orderPrice": orderPrice
        ]
    }
}
