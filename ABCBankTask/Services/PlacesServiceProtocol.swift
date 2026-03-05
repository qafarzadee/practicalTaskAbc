//  PlacesServiceProtocol.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Foundation

protocol PlacesServiceProtocol {
    func fetchPages() async throws -> [GalleryPage]
}
