//
//  MainViewController.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import UIKit

class MainViewController: UIViewController {
    typealias SectionItem = (headerViewModel: (any ViewModelType)?,
                             cellViewModels: [any ViewModelType])

    let viewModel: MainViewModel

    required init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupLayout()
    }

    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "avatar"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(avatarDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "notification"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(notificationDidTapped))
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        view.addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tabView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabView.widthAnchor.constraint(equalToConstant: 328),
            tabView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc private func avatarDidTapped() {
        print("avatar did tapped")
    }

    @objc private func notificationDidTapped() {
        print("notification did tapped")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            let sectionLayout = section.sectionItem
            return sectionLayout
        }

        layout.configuration.interSectionSpacing = 40

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(BalanceCell.self,
                      forCellWithReuseIdentifier: BalanceCell.reuseIdentifier)
        view.register(ActionCell.self,
                      forCellWithReuseIdentifier: ActionCell.reuseIdentifier)
        view.register(FavoriteCell.self,
                      forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        view.register(BannerCell.self,
                      forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        view.register(BalanceHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: BalanceHeader.reuseIdentifier)
        view.register(FavoriteHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: FavoriteHeader.reuseIdentifier)
        view.dataSource = self
        return view
    }()

    private lazy var tabView: TabView = {
        let view = TabView(viewModel: .init(tabs: viewModel.tabs))
        return view
    }()

    private var amountVisible = CurrentValueSubject<Bool, Never>(false)

    private var cancellables: Set<AnyCancellable> = []
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .balance:
            return viewModel.balances.count
        case .action:
            return viewModel.actions.count
        case .favorite:
            return viewModel.favorites.count
        case .banner:
            return viewModel.banners.isEmpty ? 0 : 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }

        switch section {
        case .balance:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCell.reuseIdentifier,
                                                                for: indexPath) as? BalanceCell else {
                return UICollectionViewCell()
            }

            cell.configure(viewModel: .init(),
                           amountVisiableDidSet: amountVisible.eraseToAnyPublisher(),
                           infoDidUpdate: Just(viewModel.balances[indexPath.item]).eraseToAnyPublisher())
            return cell
        case .action:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCell.reuseIdentifier,
                                                                for: indexPath) as? ActionCell else {
                return UICollectionViewCell()
            }

            cell.configure(viewModel: .init(type: viewModel.actions[indexPath.item]))
            return cell
        case .favorite:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier,
                                                                for: indexPath) as? FavoriteCell else {
                return UICollectionViewCell()
            }

            cell.configure(viewModel: .init(type: viewModel.favorites[indexPath.item]))
            return cell
        case .banner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier,
                                                                for: indexPath) as? BannerCell else {
                return UICollectionViewCell()
            }

            cell.configure(viewModel: .init(banners: viewModel.banners))
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionReusableView() }

        switch section {
        case .balance:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: BalanceHeader.reuseIdentifier,
                                                                   for: indexPath)

        case .favorite:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: FavoriteHeader.reuseIdentifier,
                                                                   for: indexPath)

        case .action, .banner:
            return UICollectionReusableView()
        }
    }
}
