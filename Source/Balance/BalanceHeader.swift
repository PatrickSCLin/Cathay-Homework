//
//  BalanceHeader.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import Combine
import UIKit

class BalanceHeader: UICollectionReusableView {
    static let reuseIdentifier = "BalanceHeader"

    var viewModel: BalanceHeaderViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStyle()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: BalanceHeaderViewModel) {
        self.viewModel = viewModel
        let output = viewModel.transform(.init(eyeDidTap: eyeDidTapPublisher.eraseToAnyPublisher()),
                                         cancellables: &cancellables)
        output.isAmountVisible
            .sink { [weak self] isVisible in
                guard let self else { return }

                let image = isVisible ? UIImage(named: "eye_on") : UIImage(named: "eye_off")
                self.eyeButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
    }

    private func setupStyle() {
        backgroundColor = .customBG
    }

    private func setupLayout() {
        let spaceView = UIView()
        spaceView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, eyeButton, spaceView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func eyeDidTap() {
        eyeDidTapPublisher.send(())
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .style10
        label.textColor = .customGray5
        label.text = "My Account Balance"
        return label
    }()

    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye_off"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(eyeDidTap), for: .touchUpInside)
        return button
    }()

    private let eyeDidTapPublisher = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
}
