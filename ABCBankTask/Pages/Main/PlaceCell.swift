//  PlaceCell.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class PlaceCell: UITableViewCell {
    static let reuseID = "PlaceCell"

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AppConstants.Layout.thumbnailSize / 2
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Colors.cardBackground
        view.layer.cornerRadius = AppConstants.Layout.cardCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var currentURL: String?
    private var loadingTask: Task<Void, Never>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(textStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.Layout.horizontalPadding),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.Layout.horizontalPadding),

            thumbnailImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            thumbnailImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: AppConstants.Layout.thumbnailSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: AppConstants.Layout.thumbnailSize),

            textStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        currentURL = nil
        loadingTask?.cancel()
        loadingTask = nil
    }

    func configure(item: PlaceItem, imageLoader: ImageLoaderProtocol) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        thumbnailImageView.image = UIImage(systemName: AppConstants.Images.placeholder)
        thumbnailImageView.tintColor = .systemGray3

        let url = item.imageURL
        currentURL = url

        loadingTask = Task { [weak self] in
            let image = await imageLoader.loadImage(from: url)
            guard let self = self, self.currentURL == url else { return }
            if let image = image {
                self.thumbnailImageView.image = image
            }
        }
    }
}
