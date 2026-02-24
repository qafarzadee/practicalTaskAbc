//  GalleryData.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Foundation

struct PlaceItem: Codable {
    let title: String
    let subtitle: String
    let imageURL: String
}

struct GalleryPage: Codable {
    let categoryName: String
    let imageName: String
    let items: [PlaceItem]
}

func loadGalleryPages() -> [GalleryPage] {
    guard let url = Bundle.main.url(forResource: "places", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let pages = try? JSONDecoder().decode([GalleryPage].self, from: data) else {
        return []
    }
    return pages
}
