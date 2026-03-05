//  PlaceRow.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct PlaceRow: View {
    let item: PlaceItem
    let imageLoader: ImageLoaderProtocol

    @State private var image: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: AppConstants.Layout.thumbnailSize,
                        height: AppConstants.Layout.thumbnailSize
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.thumbnailCornerRadius))
            } else {
                Image(systemName: AppConstants.Images.placeholder)
                    .foregroundColor(.gray)
                    .frame(
                        width: AppConstants.Layout.thumbnailSize,
                        height: AppConstants.Layout.thumbnailSize
                    )
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.thumbnailCornerRadius))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                Text(item.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(AppConstants.Colors.cardBackground))
        .cornerRadius(AppConstants.Layout.cardCornerRadius)
        .task {
            image = await imageLoader.loadImage(from: item.imageURL)
        }
        .onDisappear {
            imageLoader.cancelLoad(for: item.imageURL)
        }
    }
}
