//
//  BalanceHeader.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import UIKit

class BalanceHeader: UICollectionReusableView {
    static let reuseIdentifier = "BalanceHeader"

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
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style10
        label.textColor = .customGray5
        label.text = "My Account Balance"
        return label
    }()
}
