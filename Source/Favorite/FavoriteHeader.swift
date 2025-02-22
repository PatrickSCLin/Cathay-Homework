//
//  FavoriteHeader.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import UIKit

class FavoriteHeader: UICollectionReusableView {
    static let reuseIdentifier = "FavoriteHeader"

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
        let spaceView = UIView()
        spaceView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        spaceView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let rightView = UIStackView(arrangedSubviews: [moreLabel, arrowImageView])
        rightView.axis = .horizontal
        rightView.spacing = 0
        rightView.alignment = .center
        rightView.setContentHuggingPriority(.required, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, spaceView, rightView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style10
        label.textColor = .customGray5
        label.text = "My Favorite"
        return label
    }()

    private lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.font = .style2
        label.textColor = .systemGray7
        label.text = "More"
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "right_arrow"))
        return imageView
    }()
}
