//
//  FavoritePlaceholderCell.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import UIKit

class FavoritePlaceholderCell: UICollectionViewCell {
    static let reuseIdentifier = "FavoritePlaceholderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStyle()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .customBG
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [placeholderImage, placeholderLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ])
    }

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .style4
        label.textColor = .customGray6
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "You can add a favorite through the transfer or payment function."
        return label
    }()

    private lazy var placeholderImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "favorite_placeholder"))
        view.contentMode = .scaleAspectFit
        return view
    }()
}
