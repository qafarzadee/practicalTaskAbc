//  MainViewModel.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Combine
import UIKit

class MainViewModel {
    @Published var pages: [GalleryPage] = []
    @Published var currentPage: Int = 0
    @Published var searchText: String = ""

    let imageLoader: ImageLoaderProtocol
    private let placesService: PlacesServiceProtocol

    var filteredItems: [PlaceItem] {
        guard !pages.isEmpty else { return [] }
        let items = pages[currentPage].items
        guard !searchText.isEmpty else { return items }
        let query = searchText.lowercased()
        return items.filter {
            $0.title.lowercased().contains(query) || $0.subtitle.lowercased().contains(query)
        }
    }

    var currentImageName: String {
        guard !pages.isEmpty else { return "" }
        return pages[currentPage].imageName
    }

    init(placesService: PlacesServiceProtocol = MockPlacesService(),
         imageLoader: ImageLoaderProtocol = DefaultImageLoader()) {
        self.placesService = placesService
        self.imageLoader = imageLoader
    }

    func loadData() async {
        do {
            let loadedPages = try await placesService.fetchPages()
            await MainActor.run {
                self.pages = loadedPages
            }
        } catch {
            await MainActor.run {
                self.pages = []
            }
        }
    }
}
