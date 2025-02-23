//
//  NotificationCell.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import Combine
import UIKit

class NotificationCell: UITableViewCell {
    static let reuseIdentifier = "BalanceView"

    var viewModel: NotificationCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupStyle()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: NotificationCellViewModel) {
        self.viewModel = viewModel

        let output = viewModel.transform(.init(), cancellables: &cancellables)
        output.title
            .sink { [weak self] text in
                self?.titleLabel.text = text
            }
            .store(in: &cancellables)

        output.timestamp
            .sink { [weak self] text in
                self?.timestampLabel.text = text
            }
            .store(in: &cancellables)

        output.message
            .sink { [weak self] text in
                self?.messageLabel.text = text
            }
            .store(in: &cancellables)

        output.hasRead
            .sink { [weak self] hasRead in
                self?.unreadDotView.isHidden = hasRead
            }
            .store(in: &cancellables)
    }

    private func setupStyle() {
        contentView.backgroundColor = .customBG
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, timestampLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(unreadDotView)
        unreadDotView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            unreadDotView.widthAnchor.constraint(equalToConstant: 12),
            unreadDotView.heightAnchor.constraint(equalToConstant: 12),
            unreadDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            unreadDotView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22)
        ])
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style5
        label.textColor = .systemGray10
        return label
    }()

    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .style4
        label.textColor = .systemGray10
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .style2
        label.textColor = .battleshipGray
        label.numberOfLines = 0
        return label
    }()

    private lazy var unreadDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 6
        return view
    }()

    private var cancellables: Set<AnyCancellable> = []
}
