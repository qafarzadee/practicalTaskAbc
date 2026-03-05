//  MockPlacesServiceTests.swift
//  Created by Elgun Gafarzada on 20.02.26.

import XCTest
@testable import ABCBankTask

final class MockPlacesServiceTests: XCTestCase {

    func testFetchPagesReturnsData() async throws {
        let service = MockPlacesService()
        let pages = try await service.fetchPages()

        XCTAssertFalse(pages.isEmpty)
    }

    func testFetchPagesContainsExpectedCategories() async throws {
        let service = MockPlacesService()
        let pages = try await service.fetchPages()
        let categoryNames = pages.map(\.categoryName)

        XCTAssertTrue(categoryNames.contains("Historical Sites"))
        XCTAssertTrue(categoryNames.contains("Nature & Parks"))
    }

    func testEachPageHasItems() async throws {
        let service = MockPlacesService()
        let pages = try await service.fetchPages()

        for page in pages {
            XCTAssertFalse(page.items.isEmpty, "\(page.categoryName) should have items")
        }
    }

    func testPlaceItemsHaveRequiredFields() async throws {
        let service = MockPlacesService()
        let pages = try await service.fetchPages()
        let allItems = pages.flatMap(\.items)

        for item in allItems {
            XCTAssertFalse(item.title.isEmpty, "Title should not be empty")
            XCTAssertFalse(item.subtitle.isEmpty, "Subtitle should not be empty")
            XCTAssertFalse(item.imageURL.isEmpty, "Image URL should not be empty")
        }
    }
}
