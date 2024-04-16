//
//  ImageLoader.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 16/04/24.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            self.image = nil
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }.resume()
    }
}

