//  AppConstants.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

enum AppConstants {

    enum Strings {
        static let searchPlaceholder = "Search"
        static let statisticsTitle = "Statistics"
        static let itemsPerCategory = "Items per Category"
        static let topCharacters = "Top Characters"
        static let itemsSuffix = "items"
    }

    enum Images {
        static let placeholder = "photo.fill"
        static let searchIcon = "magnifyingglass"
        static let clearIcon = "xmark.circle.fill"
        static let fabIcon = "ellipsis"
    }

    enum Layout {
        static let carouselHeight: CGFloat = 220
        static let carouselCornerRadius: CGFloat = 14
        static let cardCornerRadius: CGFloat = 12
        static let thumbnailSize: CGFloat = 44
        static let thumbnailCornerRadius: CGFloat = 10
        static let searchBarCornerRadius: CGFloat = 10
        static let fabSize: CGFloat = 56
        static let fabCornerRadius: CGFloat = 28
        static let horizontalPadding: CGFloat = 16
    }

    enum Colors {
        static let fabBackground = UIColor(red: 0.29, green: 0.56, blue: 0.85, alpha: 1)
        static let cardBackground = UIColor(red: 0.86, green: 0.91, blue: 0.86, alpha: 1)
    }
}
