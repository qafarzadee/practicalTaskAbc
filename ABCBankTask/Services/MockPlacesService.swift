//  MockPlacesService.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Foundation

enum PlacesServiceError: Error {
    case fileNotFound
    case decodingFailed
}

class MockPlacesService: PlacesServiceProtocol {
    func fetchPages() async throws -> [GalleryPage] {
        guard let url = Bundle.main.url(forResource: "places", withExtension: "json") else {
            throw PlacesServiceError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let pages = try JSONDecoder().decode([GalleryPage].self, from: data)
        return pages
    }
}
