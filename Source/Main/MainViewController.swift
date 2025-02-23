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
    weak var coordinator: MainCoordinator?

    required init(viewModel: MainViewModel, coordinator: MainCoordinator? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        coordinator?.finish()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupLayout()
        setupDataSource()
        binding()
    }

    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = avatarBarButtonItem
        navigationItem.rightBarButtonItem = notificationBarButtonItem
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

//        view.addSubview(tabView)
//        tabView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            tabView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tabView.widthAnchor.constraint(equalToConstant: 328),
//            tabView.heightAnchor.constraint(equalToConstant: 50),
//        ])
    }

    private func setupDataSource() {
        dataSource = MainDataSource(collectionView: collectionView, viewModel: viewModel)
    }

    private func binding() {
        let output = viewModel.transform(.init(viewDidPull: refreshDidPullSubject.eraseToAnyPublisher(),
                                               notificationDidTap: notificationDidTapSubject.eraseToAnyPublisher()),
                                         cancellables: &cancellables)

        output.isLoadingVisible.sink { [weak self] result in
            guard let self else { return }

            if result, self.collectionView.refreshControl?.isRefreshing ?? false {
                self.collectionView.refreshControl?.endRefreshing()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
        .store(in: &cancellables)

        output.hasNewNotification
            .sink { [weak self] hasNewNotification in
                guard let self else { return }

                self.notificationBarButtonItem.image = hasNewNotification ?
                    UIImage(named: "notification_active") :
                    UIImage(named: "notification_inactive")
            }
            .store(in: &cancellables)

        Publishers.CombineLatest4(output.balances,
                                  output.actions,
                                  output.favorites,
                                  output.banners)
            .sink { [weak self] _, _, _, _ in
                self?.dataSource?.applySnapshot()
            }
            .store(in: &cancellables)
    }

    @objc private func avatarDidTap() {
        print("avatar did tapped")
    }

    @objc private func notificationDidTap() {
        coordinator?.showNotifications()
        notificationDidTapSubject.send(())
    }

    @objc private func refreshDidPull() {
        refreshDidPullSubject.send(())
    }

    private lazy var avatarBarButtonItem: UIBarButtonItem = .init(image: UIImage(named: "avatar"),
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(avatarDidTap))

    private lazy var notificationBarButtonItem: UIBarButtonItem = .init(image: UIImage(named: "notification_inactive"),
                                                                        style: .plain,
                                                                        target: self,
                                                                        action: #selector(notificationDidTap))

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self, let section = Section(rawValue: sectionIndex) else { return nil }

            return section.createSectionLayout(viewModel: self.viewModel)
        }

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .customBG
        view.alwaysBounceVertical = true
        view.register(BalanceCell.self,
                      forCellWithReuseIdentifier: BalanceCell.reuseIdentifier)
        view.register(ActionCell.self,
                      forCellWithReuseIdentifier: ActionCell.reuseIdentifier)
        view.register(FavoriteCell.self,
                      forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        view.register(FavoritePlaceholderCell.self,
                      forCellWithReuseIdentifier: FavoritePlaceholderCell.reuseIdentifier)
        view.register(BannerCell.self,
                      forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        view.register(BalanceHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: BalanceHeader.reuseIdentifier)
        view.register(FavoriteHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: FavoriteHeader.reuseIdentifier)

        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshDidPull), for: .valueChanged)
        view.refreshControl = control
        return view
    }()

    private lazy var tabView: TabView = {
        let view = TabView(viewModel: .init(tabs: viewModel.tabs))
        return view
    }()

    private var refreshDidPullSubject = PassthroughSubject<Void, Never>()
    private var notificationDidTapSubject = PassthroughSubject<Void, Never>()
    private var dataSource: MainDataSource?

    private var cancellables: Set<AnyCancellable> = []
}
