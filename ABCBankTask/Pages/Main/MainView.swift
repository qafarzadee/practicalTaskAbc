//  MainView.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    if !viewModel.pages.isEmpty {
                        ImageCarousel(pages: viewModel.pages, currentPage: $viewModel.currentPage)
                            .padding(.top, 8)
                            .padding(.bottom, 10)
                    }

                    Section {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.filteredItems, id: \.title) { item in
                                PlaceRow(
                                    item: item,
                                    imageLoader: viewModel.imageLoader
                                )
                            }
                        }
                        .padding(.horizontal, AppConstants.Layout.horizontalPadding)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    } header: {
                        searchBarView
                    }
                }
            }
            .background(Color(.systemGroupedBackground))

            fabButton
        }
        .sheet(isPresented: $viewModel.showingStats) {
            StatsSheet(pages: viewModel.pages)
                .presentationDetents([.medium])
        }
        .task {
            await viewModel.loadData()
        }
    }

    private var searchBarView: some View {
        HStack {
            Image(systemName: AppConstants.Images.searchIcon)
                .foregroundColor(.gray)
            TextField(AppConstants.Strings.searchPlaceholder, text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: AppConstants.Images.clearIcon)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(AppConstants.Layout.searchBarCornerRadius)
        .padding(.horizontal, AppConstants.Layout.horizontalPadding)
        .padding(.vertical, 6)
        .background(Color(.systemGroupedBackground))
    }

    private var fabButton: some View {
        Button { viewModel.showingStats = true } label: {
            Image(systemName: AppConstants.Images.fabIcon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: AppConstants.Layout.fabSize, height: AppConstants.Layout.fabSize)
                .background(Color(AppConstants.Colors.fabBackground))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 32)
    }
}
