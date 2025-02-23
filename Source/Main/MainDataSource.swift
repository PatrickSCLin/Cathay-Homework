//
//  MainDataSource.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import Combine
import UIKit

enum MainItem: Hashable, Sendable {
    case balance(BalanceModel)
    case action(Action)
    case favorite(FavoriteModel)
    case favoritePlaceholder
    case banner(UUID)
}

// 修改 DataSource 的泛型类型
final class MainDataSource: UICollectionViewDiffableDataSource<MainViewController.Section, MainItem> {
    let viewModel: MainViewModel

    init(collectionView: UICollectionView, viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = MainViewController.Section(rawValue: indexPath.section) else {
                return UICollectionViewCell()
            }

            switch (section, item) {
            case (.balance, .balance(let balance)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCell.reuseIdentifier,
                                                                    for: indexPath) as? BalanceCell else {
                    return UICollectionViewCell()
                }

                cell.configure(viewModel: .init(),
                               amountVisiableDidSet: viewModel.amoustVisiable.eraseToAnyPublisher(),
                               infoDidUpdate: Just(balance).eraseToAnyPublisher())
                return cell

            case (.action, .action(let action)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCell.reuseIdentifier,
                                                                    for: indexPath) as? ActionCell else {
                    return UICollectionViewCell()
                }

                cell.configure(viewModel: .init(type: action))
                return cell

            case (.favorite, .favorite(let favorite)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier,
                                                                    for: indexPath) as? FavoriteCell else {
                    return UICollectionViewCell()
                }

                cell.configure(viewModel: .init(title: favorite.nickname, type: favorite.transType))
                return cell

            case (.favorite, .favoritePlaceholder):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritePlaceholderCell.reuseIdentifier,
                                                                    for: indexPath) as? FavoritePlaceholderCell else {
                    return UICollectionViewCell()
                }

                return cell

            case (.banner, .banner(_)):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier,
                                                                    for: indexPath) as? BannerCell else {
                    return UICollectionViewCell()
                }

                cell.configure(viewModel: .init(bannerInfos: viewModel.banners))
                return cell

            default:
                return UICollectionViewCell()
            }
        }

        supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let section = MainViewController.Section(rawValue: indexPath.section) else { return UICollectionReusableView() }

            switch section {
            case .balance:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: BalanceHeader.reuseIdentifier,
                                                                                   for: indexPath) as? BalanceHeader else {
                    return UICollectionReusableView()
                }

                header.configure(viewModel: .init(amoutVisible: viewModel.amoustVisiable))
                return header

            case .favorite:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: FavoriteHeader.reuseIdentifier,
                                                                       for: indexPath)

            case .action, .banner:
                return UICollectionReusableView()
            }
        }
    }

    func applySnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<MainViewController.Section, MainItem>()

        if !viewModel.balances.isEmpty {
            snapshot.appendSections([.balance])
            snapshot.appendItems(viewModel.balances.map(MainItem.balance), toSection: .balance)
        }

        if !viewModel.actions.isEmpty {
            snapshot.appendSections([.action])
            snapshot.appendItems(viewModel.actions.map(MainItem.action), toSection: .action)
        }

        snapshot.appendSections([.favorite])
        if !viewModel.favorites.isEmpty {
            snapshot.appendItems(viewModel.favorites.map(MainItem.favorite), toSection: .favorite)
        } else {
            snapshot.appendItems([.favoritePlaceholder], toSection: .favorite)
        }

        if !viewModel.banners.isEmpty {
            snapshot.appendSections([.banner])
            snapshot.appendItems([.banner(UUID())], toSection: .banner)
        }

        apply(snapshot, animatingDifferences: animated)
    }
}
