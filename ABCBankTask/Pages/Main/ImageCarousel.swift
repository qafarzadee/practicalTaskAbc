//  ImageCarousel.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct ImageCarousel: View {
    let pages: [GalleryPage]
    @Binding var currentPage: Int

    var body: some View {
        VStack(spacing: 6) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    carouselImage(pages[index].imageName)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: AppConstants.Layout.carouselHeight)

            HStack(spacing: 7) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color(.darkGray) : Color(.systemGray4))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    @ViewBuilder
    private func carouselImage(_ name: String) -> some View {
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: AppConstants.Layout.carouselHeight)
                .clipped()
                .cornerRadius(AppConstants.Layout.carouselCornerRadius)
                .padding(.horizontal, AppConstants.Layout.horizontalPadding)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: AppConstants.Layout.carouselCornerRadius)
                    .fill(Color(.systemGray5))
                Image(systemName: AppConstants.Images.placeholder)
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
            }
            .frame(height: AppConstants.Layout.carouselHeight)
            .padding(.horizontal, AppConstants.Layout.horizontalPadding)
        }
    }
}
