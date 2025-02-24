//
//  ActionCell.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import UIKit

class ActionCell: UICollectionViewCell {
    static let reuseIdentifier = "ActionCell"

    var viewModel: ActionCellViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStyle()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables = []
    }

    func configure(viewModel: ActionCellViewModel) {
        self.viewModel = viewModel

        let output = viewModel.transform(.init(), cancellables: &cancellables)
        output.image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.iconView.image = $0 }
            .store(in: &cancellables)
        output.title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.titleLabel.text = $0 }
            .store(in: &cancellables)
    }

    private func setupStyle() {
        backgroundColor = .customBG
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillProportionally

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .style4
        view.textColor = .systemGray7
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()

    private var cancellables: Set<AnyCancellable> = []
}
