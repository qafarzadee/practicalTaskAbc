//  CarouselCell.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class CarouselCell: UICollectionViewCell {
    static let reuseID = "CarouselCell"

    private let carouselImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AppConstants.Layout.carouselCornerRadius
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let placeholderIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: AppConstants.Images.placeholder))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(carouselImageView)
        carouselImageView.addSubview(placeholderIcon)
        NSLayoutConstraint.activate([
            carouselImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carouselImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            carouselImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.Layout.horizontalPadding),
            carouselImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.Layout.horizontalPadding),
            placeholderIcon.centerXAnchor.constraint(equalTo: carouselImageView.centerXAnchor),
            placeholderIcon.centerYAnchor.constraint(equalTo: carouselImageView.centerYAnchor),
            placeholderIcon.widthAnchor.constraint(equalToConstant: 48),
            placeholderIcon.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(imageName: String) {
        if let image = UIImage(named: imageName) {
            carouselImageView.image = image
            placeholderIcon.isHidden = true
        } else {
            carouselImageView.image = nil
            placeholderIcon.isHidden = false
        }
    }
}
