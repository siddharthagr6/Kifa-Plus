//
//  AddItemView.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import UIKit


struct AddItemView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedImage: UIImage?
    @State private var isPhotoLibraryPresented = false
    @State private var isCameraPresented = false


    // Product fields
    @State var productName: String = ""
    @State var productDescription: String = ""
    @State var productGender: String = ""
    @State var productMaterial: String = ""
    @State var productPrice: String = ""
    @State var productSize: String = ""
    @State var productType: String = ""

    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $productName)
                    TextField("Product Description", text: $productDescription)
                    TextField("Product Gender", text: $productGender)
                    TextField("Product Material", text: $productMaterial)
                    TextField("Product Price", text: $productPrice)
                    TextField("Product Size", text: $productSize)
                    TextField("Product Type", text: $productType)

                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }

                    Button("Choose Image from Library") {
                                            self.isPhotoLibraryPresented = true
                                        }

                                        Button("Take Photo with Camera") {
                                            self.isCameraPresented = true
                                        }
                                    }
                                    .sheet(isPresented: $isPhotoLibraryPresented) {
                                        ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                                    }
                                    .sheet(isPresented: $isCameraPresented) {
                                        ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                                    }

                Button("Add Product") {
                    addNewProduct()
                }
            }
            .navigationBarTitle("Add New Product")
        }.navigationViewStyle(StackNavigationViewStyle())
           
    }

    private func addNewProduct() {
        // Upload the image first
        uploadImage(selectedImage) { imageUrl in
            // Construct the product data
            let productData: [String: Any] = [
                "productName": self.productName,
                "productDescription": self.productDescription,
                "productGender": self.productGender,
                "productMaterial": self.productMaterial,
                "productPrice": self.productPrice,
                "productSize": self.productSize,
                "productType": self.productType,
                "productURL": imageUrl,
                "productTime": Timestamp(date: Date()),
                "productStatus": ProductStatus.available.rawValue
            ]

            // Upload product data to Firestore
            let db = Firestore.firestore()
            db.collection("products").addDocument(data: productData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    resetForm()
                }
            }
        }
    }

    private func uploadImage(_ image: UIImage?, completion: @escaping (String) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.4) else {
            completion("")
            return
        }

        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion("")
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    completion("")
                    return
                }

                if let imageUrl = url?.absoluteString {
                    completion(imageUrl)
                } else {
                    completion("")
                }
            }
        }
    }

    private func resetForm() {
        self.selectedImage = nil
        self.productName = ""
        self.productDescription = ""
        self.productGender = ""
        self.productMaterial = ""
        self.productPrice = ""
        self.productSize = ""
        self.productType = ""
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

