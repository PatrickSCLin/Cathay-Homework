//
//  CarouselCell.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

class CarouselCell: UICollectionViewCell {
    static let reuseIdentifier = "CarouselCell"

    var viewModel: CarouselCellViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)

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

    func configure(viewModel: CarouselCellViewModel) {
        self.viewModel = viewModel

        let output = self.viewModel?.transform(.init(), cancellables: &cancellables)
        output?.image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.imageView.image = $0 }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return view
    }()

    private var cancellables: Set<AnyCancellable> = []
}
