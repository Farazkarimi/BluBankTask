//
//  UIImageView+Extension.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()

    func loadImage(fromURL urlString: String, placeholder: UIImage? = nil, showLoadingIndicator: Bool = true, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            NSLog("Invalid URL: \(urlString)")
            return
        }

        var loadingIndicator: UIActivityIndicatorView?
        if showLoadingIndicator {
            loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator?.startAnimating()
            loadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(loadingIndicator!)
            NSLayoutConstraint.activate([
                loadingIndicator!.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingIndicator!.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }

        if let placeholder = placeholder {
            self.image = placeholder
        }

        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            loadingIndicator?.stopAnimating()
            loadingIndicator?.removeFromSuperview()
            completion?()
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let imageData = try Data(contentsOf: url)
                if let image = UIImage(data: imageData) {
                    UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                    DispatchQueue.main.async {
                        self.image = image
                        loadingIndicator?.stopAnimating()
                        loadingIndicator?.removeFromSuperview()
                        completion?()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = nil
                        loadingIndicator?.stopAnimating()
                        loadingIndicator?.removeFromSuperview()
                        completion?()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = nil
                    loadingIndicator?.stopAnimating()
                    loadingIndicator?.removeFromSuperview()
                    completion?()
                }
            }
        }
    }
}
