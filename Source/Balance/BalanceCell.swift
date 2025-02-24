//
//  BalanceCell.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import UIKit

class BalanceCell: UICollectionViewCell {
    static let reuseIdentifier = "BalanceView"

    var viewModel: BalanceCellViewModel?

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

    func configure(viewModel: BalanceCellViewModel, amountVisiableDidSet: AnyPublisher<Bool, Never>, infoDidUpdate: AnyPublisher<BalanceModel, Never>) {
        self.viewModel = viewModel

        let output = self.viewModel?.transform(.init(amountVisiableDidSet: amountVisiableDidSet,
                                                     infoDidUpdate: infoDidUpdate),
                                               cancellables: &cancellables)

        output?.currency
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.currencyLabel.text = $0 }
            .store(in: &cancellables)

        output?.amount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.amountLabel.text = $0 }
            .store(in: &cancellables)

        output?.isAmountVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAmountVisiable in
                self?.amountLabel.isHidden = !isAmountVisiable
                self?.secureLabel.isHidden = isAmountVisiable
            }
            .store(in: &cancellables)
    }

    private func setupStyle() {
        backgroundColor = .customBG
    }

    private func setupLayout() {
        let amountView = UIView()
        amountView.addSubview(amountLabel)
        amountView.addSubview(secureLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        secureLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: amountView.topAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: amountView.bottomAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: amountView.leadingAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: amountView.bottomAnchor),
            secureLabel.topAnchor.constraint(equalTo: amountView.topAnchor),
            secureLabel.bottomAnchor.constraint(equalTo: amountView.bottomAnchor),
            secureLabel.leadingAnchor.constraint(equalTo: amountView.leadingAnchor),
            secureLabel.bottomAnchor.constraint(equalTo: amountView.bottomAnchor),
        ])

        let stackView = UIStackView(arrangedSubviews: [
            currencyLabel,
            amountView,
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.distribution = .fillProportionally

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
        ])
    }

    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .style2
        label.textColor = .systemGray7
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .style3
        label.textColor = .systemGray8
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var secureLabel: UILabel = {
        let label = UILabel()
        label.text = "********"
        label.font = .style3
        label.textColor = .systemGray8
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    private var cancellables: Set<AnyCancellable> = []
}
