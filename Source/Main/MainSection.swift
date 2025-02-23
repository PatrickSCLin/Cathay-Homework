//
//  MainSectionProvider.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import UIKit

extension MainViewController {
    enum Section: Int {
        case balance
        case action
        case favorite
        case banner

        func createItemLayout(viewModel: MainViewModel) -> NSCollectionLayoutItem {
            switch self {
            case .balance:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(64)))
            case .action:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(0.33),
                                               heightDimension: .estimated(96)))
            case .favorite:
                var fractionalWidth = CGFloat(0.25)
                if viewModel.favorites.isEmpty {
                    fractionalWidth = 1
                } else if viewModel.favorites.count > 4 {
                    fractionalWidth = 0.2
                }
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(fractionalWidth),
                                               heightDimension: .estimated(88)))
            case .banner:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(132)))
            }
        }

        func createHeaderLayout(viewModel: MainViewModel) -> NSCollectionLayoutBoundarySupplementaryItem {
            switch self {
            case .balance:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(48)),
                             elementKind: UICollectionView.elementKindSectionHeader,
                             alignment: .top)
            case .action:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(0)),
                             elementKind: UICollectionView.elementKindSectionHeader,
                             alignment: .top)
            case .favorite:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(48)),
                             elementKind: UICollectionView.elementKindSectionHeader,
                             alignment: .top)
            case .banner:
                return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(0)),
                             elementKind: UICollectionView.elementKindSectionHeader,
                             alignment: .top)
            }
        }

        func createGroupLayout(viewModel: MainViewModel) -> NSCollectionLayoutGroup {
            let itemLayout = createItemLayout(viewModel: viewModel)
            switch self {
            case .balance:
                let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                     heightDimension: .estimated(128)),
                                                                   subitems: [itemLayout])
                return groupLayout
            case .action:
                let innerGroupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                            heightDimension: .estimated(96)),
                                                                          subitems: [itemLayout])
                let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                     heightDimension: .estimated(192)),
                                                                   subitems: [innerGroupLayout])
                return groupLayout
            case .favorite:
                let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                       heightDimension: .estimated(88)),
                                                                     subitems: [itemLayout])
                return groupLayout
            case .banner:
                let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                     heightDimension: .estimated(132)),
                                                                   subitems: [itemLayout])
                return groupLayout
            }
        }

        func createSectionLayout(viewModel: MainViewModel) -> NSCollectionLayoutSection {
            let groupLayout = createGroupLayout(viewModel: viewModel)
            switch self {
            case .balance:
                groupLayout.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
                let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
                let headerLayout = createHeaderLayout(viewModel: viewModel)
                headerLayout.contentInsets = .init(top: 0, leading: 24, bottom: 8, trailing: 24)
                sectionLayout.boundarySupplementaryItems = [headerLayout]
                return sectionLayout
            case .action:
                let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
                sectionLayout.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
                return sectionLayout
            case .favorite:
                let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
                let headerLayout = createHeaderLayout(viewModel: viewModel)
                if viewModel.favorites.isEmpty {
                    headerLayout.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 16)
                    sectionLayout.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
                } else {
                    headerLayout.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16)
                    sectionLayout.contentInsets = .init(top: 0, leading: 24, bottom: 8, trailing: 0)
                }

                sectionLayout.boundarySupplementaryItems = [headerLayout]
                sectionLayout.orthogonalScrollingBehavior = .paging
                return sectionLayout
            case .banner:
                return NSCollectionLayoutSection(group: groupLayout)
            }
        }
    }
}
