//
//  ContentView.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

        var body: some View {
            
                TabView {
                    ItemsView(viewModel: viewModel)
                        .tabItem {
                            Label("Items", systemImage: "list.bullet")
                        }
                    AddItemView(viewModel: viewModel)
                        .tabItem {
                            Label("Add Item", systemImage: "plus")
                        }
                    OrdersListView(viewModel: viewModel)
                        .tabItem {
                            Label("Pending Orders", systemImage: "hourglass")
                        }
                    OrdersCompletedView(viewModel: viewModel)
                        .tabItem {
                            Label("Completed Orders", systemImage: "checkmark.circle")
                        }
            }
        }
}

extension Color {
    static let Pluie = Color(red: 191 / 255, green: 125 / 255, blue: 94 / 255)  // Example RGB values
}

#Preview{
    ContentView()
}



