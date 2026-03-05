//  MainViewModelTests.swift
//  Created by Elgun Gafarzada on 20.02.26.

import XCTest
import Combine
@testable import ABCBankTask

final class MockTestPlacesService: PlacesServiceProtocol {
    var mockPages: [GalleryPage] = []
    var shouldThrowError = false

    func fetchPages() async throws -> [GalleryPage] {
        if shouldThrowError {
            throw PlacesServiceError.fileNotFound
        }
        return mockPages
    }
}

final class MockTestImageLoader: ImageLoaderProtocol {
    func loadImage(from url: String) async -> UIImage? {
        return nil
    }

    func cancelLoad(for url: String) {}
}

@MainActor
final class MainViewModelTests: XCTestCase {

    private var viewModel: MainViewModel!
    private var mockService: MockTestPlacesService!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockService = MockTestPlacesService()
        viewModel = MainViewModel(
            placesService: mockService,
            imageLoader: MockTestImageLoader()
        )
    }

    func testLoadDataSetsPages() async {
        let testPages = [
            GalleryPage(
                categoryName: "Test Category",
                imageName: "test_image",
                items: [
                    PlaceItem(title: "Place 1", subtitle: "Subtitle 1", imageURL: "https://example.com/1.jpg"),
                    PlaceItem(title: "Place 2", subtitle: "Subtitle 2", imageURL: "https://example.com/2.jpg")
                ]
            )
        ]
        mockService.mockPages = testPages

        await viewModel.loadData()

        XCTAssertEqual(viewModel.pages.count, 1)
        XCTAssertEqual(viewModel.pages.first?.categoryName, "Test Category")
        XCTAssertEqual(viewModel.pages.first?.items.count, 2)
    }

    func testLoadDataHandlesError() async {
        mockService.shouldThrowError = true

        await viewModel.loadData()

        XCTAssertTrue(viewModel.pages.isEmpty)
    }

    func testFilteredItemsReturnsAllWhenSearchEmpty() async {
        let testPages = [
            GalleryPage(
                categoryName: "Category",
                imageName: "img",
                items: [
                    PlaceItem(title: "Bahrain Fort", subtitle: "Historical site", imageURL: ""),
                    PlaceItem(title: "Al Fateh Mosque", subtitle: "Religious site", imageURL: "")
                ]
            )
        ]
        mockService.mockPages = testPages
        await viewModel.loadData()
        viewModel.searchText = ""

        XCTAssertEqual(viewModel.filteredItems.count, 2)
    }

    func testFilteredItemsFiltersByTitle() async {
        let testPages = [
            GalleryPage(
                categoryName: "Category",
                imageName: "img",
                items: [
                    PlaceItem(title: "Bahrain Fort", subtitle: "Historical site", imageURL: ""),
                    PlaceItem(title: "Al Fateh Mosque", subtitle: "Religious site", imageURL: "")
                ]
            )
        ]
        mockService.mockPages = testPages
        await viewModel.loadData()
        viewModel.searchText = "Fort"

        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems.first?.title, "Bahrain Fort")
    }

    func testFilteredItemsFiltersBySubtitle() async {
        let testPages = [
            GalleryPage(
                categoryName: "Category",
                imageName: "img",
                items: [
                    PlaceItem(title: "Bahrain Fort", subtitle: "Historical site", imageURL: ""),
                    PlaceItem(title: "Al Fateh Mosque", subtitle: "Religious site", imageURL: "")
                ]
            )
        ]
        mockService.mockPages = testPages
        await viewModel.loadData()
        viewModel.searchText = "Religious"

        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems.first?.title, "Al Fateh Mosque")
    }

    func testFilteredItemsIsCaseInsensitive() async {
        let testPages = [
            GalleryPage(
                categoryName: "Category",
                imageName: "img",
                items: [
                    PlaceItem(title: "Bahrain Fort", subtitle: "Historical site", imageURL: "")
                ]
            )
        ]
        mockService.mockPages = testPages
        await viewModel.loadData()
        viewModel.searchText = "bahrain"

        XCTAssertEqual(viewModel.filteredItems.count, 1)
    }

    func testCurrentPageChangesFilteredItems() async {
        let testPages = [
            GalleryPage(
                categoryName: "Historical",
                imageName: "img1",
                items: [
                    PlaceItem(title: "Fort", subtitle: "Old fort", imageURL: "")
                ]
            ),
            GalleryPage(
                categoryName: "Nature",
                imageName: "img2",
                items: [
                    PlaceItem(title: "Garden", subtitle: "Beautiful garden", imageURL: ""),
                    PlaceItem(title: "Beach", subtitle: "Sandy beach", imageURL: "")
                ]
            )
        ]
        mockService.mockPages = testPages
        await viewModel.loadData()

        viewModel.currentPage = 0
        XCTAssertEqual(viewModel.filteredItems.count, 1)

        viewModel.currentPage = 1
        XCTAssertEqual(viewModel.filteredItems.count, 2)
    }
}
