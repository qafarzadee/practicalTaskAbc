//  ContentView.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct ContentView: View {
    @State private var currentPage = 0
    @State private var searchText = ""
    @State private var showingStats = false

    private let pages = galleryPages

    private var filtered: [PlaceItem] {
        let list = pages[currentPage].items
        guard !searchText.isEmpty else { return list }
        let q = searchText.lowercased()
        return list.filter { $0.title.lowercased().contains(q) || $0.subtitle.lowercased().contains(q) }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ImageCarousel(pages: pages, currentPage: $currentPage)
                        .padding(.top, 8)
                        .padding(.bottom, 10)

                    Section {
                        LazyVStack(spacing: 10) {
                            ForEach(filtered, id: \.title) { item in
                                PlaceRow(item: item, imgName: pages[currentPage].imageName)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    } header: {
                        searchBarView
                    }
                }
            }
            .background(Color(.systemGroupedBackground))

            Button { showingStats = true } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(red: 0.29, green: 0.56, blue: 0.85))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 32)
        }
        .sheet(isPresented: $showingStats) {
            StatsSheet(pages: pages)
                .presentationDetents([.medium])
        }
    }

    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $searchText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(Color(.systemGroupedBackground))
    }
}
