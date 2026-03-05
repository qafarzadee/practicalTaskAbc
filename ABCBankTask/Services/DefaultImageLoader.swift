//  DefaultImageLoader.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class DefaultImageLoader: ImageLoaderProtocol {
    private let cache = NSCache<NSString, UIImage>()
    private var activeTasks: [String: URLSessionDataTask] = [:]
    private let lock = NSLock()

    func loadImage(from url: String) async -> UIImage? {
        let key = url as NSString

        if let cached = cache.object(forKey: key) {
            return cached
        }

        guard let requestURL = URL(string: url) else {
            return nil
        }

        var request = URLRequest(url: requestURL)
        request.setValue("ABCBankTask/1.0", forHTTPHeaderField: "User-Agent")

        return await withCheckedContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let self = self else {
                    continuation.resume(returning: nil)
                    return
                }

                self.lock.lock()
                self.activeTasks.removeValue(forKey: url)
                self.lock.unlock()

                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    continuation.resume(returning: nil)
                    return
                }

                self.cache.setObject(image, forKey: key)
                continuation.resume(returning: image)
            }

            lock.lock()
            activeTasks[url] = task
            lock.unlock()

            task.resume()
        }
    }

    func cancelLoad(for url: String) {
        lock.lock()
        let task = activeTasks.removeValue(forKey: url)
        lock.unlock()
        task?.cancel()
    }
}
