//  ImageLoaderProtocol.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: String) async -> UIImage?
    func cancelLoad(for url: String)
}
