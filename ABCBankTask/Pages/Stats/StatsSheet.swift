//  StatsSheet.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct StatsSheet: View {
    let pages: [GalleryPage]

    var body: some View {
        NavigationView {
            List {
                Section(AppConstants.Strings.itemsPerCategory) {
                    ForEach(pages.indices, id: \.self) { index in
                        HStack {
                            Text(pages[index].categoryName)
                            Spacer()
                            Text("\(pages[index].items.count) \(AppConstants.Strings.itemsSuffix)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section(AppConstants.Strings.topCharacters) {
                    ForEach(topCharacters().prefix(3), id: \.0) { character, count in
                        HStack {
                            Text(String(character).uppercased())
                                .font(.system(size: 17, weight: .semibold, design: .monospaced))
                            Spacer()
                            Text("\(count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(AppConstants.Strings.statisticsTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func topCharacters() -> [(Character, Int)] {
        let frequency = pages
            .flatMap(\.items)
            .flatMap { $0.title.lowercased() }
            .filter(\.isLetter)
            .reduce(into: [Character: Int]()) { result, character in
                result[character, default: 0] += 1
            }
        return frequency.sorted { $0.value > $1.value }
    }
}
