//
//  BannerCell.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import UIKit

class BannerCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerCell"

    var viewModel: BannerCellViewModel?

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

    func configure(viewModel: BannerCellViewModel) {
        self.viewModel = viewModel

        let output = viewModel.transform(.init(), cancellables: &cancellables)
        output.banners
            .map { banners in banners.map { $0.image } }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.carouselView
                    .configure(viewModel: .init(images: images,
                                                currentIndex: UserDefaults.standard.currentBannerIndex))
            }
            .store(in: &cancellables)
    }

    private func setupStyle() {
        backgroundColor = .customBG
    }

    private func setupLayout() {
        contentView.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            carouselView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            carouselView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            carouselView.widthAnchor.constraint(equalToConstant: 328),
            carouselView.heightAnchor.constraint(equalToConstant: 114),
        ])
    }

    private lazy var carouselView: CarouselView = {
        let view = CarouselView()
        return view
    }()

    private var cancellables: Set<AnyCancellable> = []
}
