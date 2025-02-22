//
//  CarouselView.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

class CarouselView: UIView {
    var viewModel: CarouselViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: CarouselViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()

        pageControl.numberOfPages = viewModel.images.count

        let input = CarouselViewModel.Input(
            viewDidAppear: viewDidAppearSubject.eraseToAnyPublisher(),
            viewDidEndDecelerating: viewDidEndDeceleratingSubject.eraseToAnyPublisher(),
            viewWillBeginDragging: viewWillBeginDraggingSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input, cancellables: &cancellables)

        output.currentIndex
            .filter { [weak self] index in
                guard let self else { return false }

                return index < (self.viewModel?.images.count ?? 0)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.scrollToItem(at: index, animated: true)
                self?.pageControl.currentPage = index
            }
            .store(in: &cancellables)

        viewDidAppearSubject.send(())
    }

    private func setupLayout() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func scrollToItem(at index: Int, animated: Bool) {
        guard let viewModel, index < viewModel.images.count else { return }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self

        view.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
        return view
    }()

    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = .systemGray4
        view.hidesForSinglePage = true
        return view
    }()

    private let viewDidAppearSubject = PassthroughSubject<Void, Never>()
    private let viewDidEndDeceleratingSubject = PassthroughSubject<Int, Never>()
    private let viewWillBeginDraggingSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
}

extension CarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier,
                                                                           for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }

        cell.configure(viewModel: .init(image: viewModel.images[indexPath.item]))
        return cell
    }
}

extension CarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewWillBeginDraggingSubject.send(())
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        viewDidEndDeceleratingSubject.send(currentIndex)
    }
}

protocol CarouselViewDelegate: AnyObject {
    func carouselViewWillBeginDragging(_ carouselView: CarouselView)
    func carouselViewDidEndDecelerating(_ carouselView: CarouselView, currentIndex: Int)
}
