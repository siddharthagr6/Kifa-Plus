//
//  OrdersCompletedView.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import SwiftUI

struct OrdersCompletedView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.completedOrders) { order in
                NavigationLink(destination: OrderDetailView(order: order)) {
                    VStack(alignment: .leading) {
                        Text(order.checkoutName)
                            .font(.headline)
                        Text(order.checkoutNumber)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Completed Orders")
            .onAppear {
                viewModel.fetchCompletedOrders()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            
    }
}
