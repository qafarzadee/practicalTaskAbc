//  PlaceCell.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class PlaceCell: UITableViewCell {
    static let reuseID = "PlaceCell"

    private let thumbView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()

    private let subtitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 2
        return lbl
    }()

    private let card: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.86, green: 0.91, blue: 0.86, alpha: 1)
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(card)

        let textStack = UIStackView(arrangedSubviews: [titleLbl, subtitleLbl])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(thumbView)
        card.addSubview(textStack)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            thumbView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            thumbView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            thumbView.widthAnchor.constraint(equalToConstant: 44),
            thumbView.heightAnchor.constraint(equalToConstant: 44),

            textStack.leadingAnchor.constraint(equalTo: thumbView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(item: PlaceItem, imageName: String) {
        titleLbl.text = item.title
        subtitleLbl.text = item.subtitle
        thumbView.image = UIImage(named: imageName) ?? UIImage(systemName: "photo.fill")
    }
}
