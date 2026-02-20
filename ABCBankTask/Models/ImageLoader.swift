//  ImageLoader.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private static var cache = NSCache<NSString, UIImage>()

    func load(from url: String) {
        let key = url as NSString
        if let cached = Self.cache.object(forKey: key) {
            self.image = cached
            return
        }
        guard let realURL = URL(string: url) else { return }
        var req = URLRequest(url: realURL)
        req.setValue("ABCBankTask/1.0", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: req) { [weak self] data, _, _ in
            guard let data = data, let img = UIImage(data: data) else { return }
            Self.cache.setObject(img, forKey: key)
            DispatchQueue.main.async { self?.image = img }
        }.resume()
    }
}
