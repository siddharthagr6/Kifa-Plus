//
//  OrderDetailView.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import SwiftUI

struct OrderDetailView: View {
    var order: Order
    
    private var totalBill: Double {
            order.items.reduce(0) { total, item in
                total + (Double(item.productPrice) ?? 0)
            }
        }

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Display Checkout Name and Number
                                Group {
                                    Text("Checkout Name: \(order.checkoutName)")
                                        .font(Font.custom("Maharlika-Regular", size: 16))
                                        .padding(.vertical, 2)
                                    
                                    Text("Checkout Number: \(order.checkoutNumber)")
                                        .font(Font.custom("Maharlika-Regular", size: 16))
                                        .padding(.vertical, 2)
                                }

                                Divider()
                
                Text("Order Items")
                    .font(.headline)
                    .padding(.top)

                
                    ForEach(order.items) { item in
                        HStack {
                            AsyncImage(url: URL(string: item.productURL)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.productName)
                                    .fontWeight(.medium)
                                
                                Text("₹\(item.productPrice)")
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                

                Text("Address Details")
                    .font(.headline)
                    .padding(.vertical)

                VStack(alignment: .leading, spacing: 3) {
                    Text(order.address.line1)
                    if !order.address.line2.isEmpty { Text(order.address.line2) }
                    if !order.address.line3.isEmpty { Text(order.address.line3) }
                    Text(order.address.cityName)
                    Text(order.address.postalCode)
                    Text(order.address.mobileNumber)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.bottom)

                Divider()

                HStack {
                    Text("Total Bill: ₹\(String(format: "%.2f", totalBill))")
                        .font(Font.custom("Maharlika-Regular", size: 20))
                                        .fontWeight(.bold)
                                        .padding(.top)
                }
                .padding()

                HStack {
                    Text("Order Status:")
                        .font(Font.custom("Maharlika-Regular", size: 20))
                        
                    Spacer()
                    Text(order.orderStatus.rawValue)
                        .font(Font.custom("Maharlika-Regular", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(order.orderStatus == .completed ? .green : .orange)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        
            
    }
}

