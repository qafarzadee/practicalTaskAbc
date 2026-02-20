//  CarouselCell.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class CarouselCell: UICollectionViewCell {
    static let reuseID = "CarouselCell"

    private let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let placeholderIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "photo.fill"))
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgView)
        imgView.addSubview(placeholderIcon)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            placeholderIcon.centerXAnchor.constraint(equalTo: imgView.centerXAnchor),
            placeholderIcon.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            placeholderIcon.widthAnchor.constraint(equalToConstant: 48),
            placeholderIcon.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(imageName: String) {
        if let img = UIImage(named: imageName) {
            imgView.image = img
            placeholderIcon.isHidden = true
        } else {
            imgView.image = nil
            placeholderIcon.isHidden = false
        }
    }
}
