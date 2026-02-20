//  ImageCarousel.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct ImageCarousel: View {
    let pages: [GalleryPage]
    @Binding var currentPage: Int

    var body: some View {
        VStack(spacing: 6) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { idx in
                    carouselImage(pages[idx].imageName)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 220)

            HStack(spacing: 7) {
                ForEach(pages.indices, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? Color(.darkGray) : Color(.systemGray4))
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
                .frame(height: 220)
                .clipped()
                .cornerRadius(14)
                .padding(.horizontal, 16)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray5))
                Image(systemName: "photo.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
            }
            .frame(height: 220)
            .padding(.horizontal, 16)
        }
    }
}
