//  GalleryData.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Foundation

struct PlaceItem: Codable, Hashable {
    let title: String
    let subtitle: String
    let imageURL: String
}

struct GalleryPage: Codable {
    let categoryName: String
    let imageName: String
    let items: [PlaceItem]
}
