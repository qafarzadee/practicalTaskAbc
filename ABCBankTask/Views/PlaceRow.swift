//  PlaceRow.swift
//  Created by Elgun Gafarzada on 20.02.26.

import SwiftUI

struct PlaceRow: View {
    let item: PlaceItem
    let imgName: String

    @StateObject private var loader = ImageLoader()

    var body: some View {
        HStack(spacing: 12) {
            if let img = loader.image {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "photo.fill")
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
        .background(Color(red: 0.86, green: 0.91, blue: 0.86))
        .cornerRadius(12)
        .onAppear { loader.load(from: item.imageURL) }
    }
}
