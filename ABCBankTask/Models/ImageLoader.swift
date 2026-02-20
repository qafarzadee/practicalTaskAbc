//  ImageLoader.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private var cache = NSCache<NSString, UIImage>()

    func load(url: String, completion: @escaping (UIImage?) -> Void) {
        let key = url as NSString
        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }
        guard let realURL = URL(string: url) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: realURL) { [weak self] data, _, _ in
            guard let data = data, let img = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self?.cache.setObject(img, forKey: key)
            DispatchQueue.main.async { completion(img) }
        }.resume()
    }
}
