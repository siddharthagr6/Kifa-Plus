//
//  ViewModel.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import SwiftUI
import FirebaseFirestore

class ViewModel: ObservableObject {
    @Published var pendingOrders: [Order] = []
    @Published var completedOrders: [Order] = []
    @Published var products: [Product] = []
    
    private let db = Firestore.firestore()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        let db = Firestore.firestore()
        db.collection("products").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    self.products = querySnapshot?.documents.compactMap { document -> Product? in
                        return Product(from: document)
                    } ?? []
                }
            }
        }
    }

        
    func fetchPendingOrders() {
            db.collection("Pending Orders").getDocuments { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents in 'Pending Orders'")
                    return
                }

                self.pendingOrders = documents.map { queryDocumentSnapshot -> Order in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    return Order(id: id, data: data)
                }
            }
        }
    
    func completeOrder(order: Order) {
        // Assuming 'db' is your Firestore reference
        let userEmail = order.userEmail  // Use the userEmail directly

        // Update the order status to completed
        var completedOrderData = order.dictionaryRepresentation
        completedOrderData["orderStatus"] = OrderStatus.completed.rawValue

        // Add the completed order to the "Orders Completed" collection
        db.collection("Orders Completed").addDocument(data: completedOrderData) { [weak self] error in
            if let error = error {
                print("Error adding completed order: \(error.localizedDescription)")
            } else {
                // Remove the order from "Pending Orders" collection
                self?.db.collection("Pending Orders").document(order.id).delete { error in
                    if let error = error {
                        print("Error removing order from pending: \(error.localizedDescription)")
                    } else {
                        // Update the local pendingOrders array if applicable
                        DispatchQueue.main.async {
                            self?.pendingOrders.removeAll { $0.id == order.id }
                        }

                        // Construct the orderText from item names
                        let itemNames = order.items.map { $0.productName }.joined(separator: ", ")
                        let notificationData: [String: Any] = [
                            "orderTime": order.orderTime,  // Assuming orderTime is part of your Order struct
                            "orderName": order.checkoutName,
                            "orderText": "Order Completed: \(itemNames)",  // Constructed string of item names
                            "orderPrice": order.totalBill ?? "0"
                        ]

                        // Add the notification to the "User Notifications" collection
                        self?.db.collection("Users").document(userEmail).collection("User Notifications").addDocument(data: notificationData) { error in
                            if let error = error {
                                print("Error adding order completion notification: \(error.localizedDescription)")
                            } else {
                                print("Order completion notification added successfully.")
                            }
                        }
                    }
                }
            }
        }
    }

    func fetchCompletedOrders() {
        db.collection("Orders Completed").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'Orders Completed'")
                return
            }

            self.completedOrders = documents.map { queryDocumentSnapshot -> Order in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                return Order(id: id, data: data)
            }
        }        }
        
}


