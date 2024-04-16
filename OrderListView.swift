//
//  OrderListView.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import SwiftUI

struct OrdersListView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedOrder: Order?  // State to hold the selected order for navigation

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.pendingOrders) { order in
                        HStack{
                            HStack {
                                NavigationLink(destination: OrderDetailView(order: order)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(order.checkoutName).font(.headline)
                                            Text(order.checkoutNumber).font(.subheadline)
                                            
                                            // Displaying the order time
                                            Text("Order Time: \(order.orderTime.formatted())") // Using the formatted() method for Date
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }

                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.completeOrder(order: order)
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    }
                }  // Using the custom color
                .navigationBarTitle("Pending Orders", displayMode: .inline)
                .onAppear {
                            viewModel.fetchPendingOrders()
                        }

                
            }.navigationViewStyle(StackNavigationViewStyle())
            
        }
}

