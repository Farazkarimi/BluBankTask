//
//  UIImageView+Extension.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()

    func loadImage(fromURL urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
           return print("Invalid URL: \(urlString)")
        }
        if let placeholder = placeholder {
            self.image = placeholder
        }

        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let imageData = try Data(contentsOf: url)
                if let image = UIImage(data: imageData) {
                    // Cache the downloaded image
                    UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = nil
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}
