//  StatsSheet.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct StatsSheet: View {
    let pages: [GalleryPage]

    var body: some View {
        NavigationView {
            List {
                Section("Items per Category") {
                    ForEach(pages.indices, id: \.self) { i in
                        HStack {
                            Text(pages[i].categoryName)
                            Spacer()
                            Text("\(pages[i].items.count) items")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section("Top Characters") {
                    ForEach(topChars().prefix(3), id: \.0) { ch, cnt in
                        HStack {
                            Text(String(ch).uppercased())
                                .font(.system(size: 17, weight: .semibold, design: .monospaced))
                            Spacer()
                            Text("\(cnt)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func topChars() -> [(Character, Int)] {
        var freq: [Character: Int] = [:]
        for page in pages {
            for item in page.items {
                for ch in item.title.lowercased() where ch.isLetter {
                    freq[ch, default: 0] += 1
                }
            }
        }
        return freq.sorted { $0.value > $1.value }
    }
}
