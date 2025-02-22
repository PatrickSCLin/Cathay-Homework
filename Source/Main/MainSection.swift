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

        var layoutItem: NSCollectionLayoutItem {
            switch self {
            case .balance:
                return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .estimated(64)))
            case .action:
                return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.33),
                                                                heightDimension: .estimated(96)))
            case .favorite:
                return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25),
                                                                heightDimension: .estimated(88)))
            case .banner:
                return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .estimated(132)))
            }
        }

        var headerItem: NSCollectionLayoutBoundarySupplementaryItem {
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

        var groupItem: NSCollectionLayoutGroup {
            switch self {
            case .balance:
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                               heightDimension: .estimated(128)),
                                                             subitems: [self.layoutItem])
                return group
            case .action:
                let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                      heightDimension: .estimated(96)),
                                                                    subitems: [self.layoutItem])
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                               heightDimension: .estimated(192)),
                                                             subitems: [innerGroup])
                return group
            case .favorite:
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .estimated(88)),
                                                               subitems: [self.layoutItem])
                return group
            case .banner:
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                               heightDimension: .estimated(132)),
                                                             subitems: [self.layoutItem])
                return group
            }
        }

        var sectionItem: NSCollectionLayoutSection {
            switch self {
            case .balance:
                let group = self.groupItem
                group.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
                let section = NSCollectionLayoutSection(group: group)
                let header = self.headerItem
                header.contentInsets = .init(top: 0, leading: 24, bottom: 8, trailing: 24)
                section.boundarySupplementaryItems = [header]
                return section
            case .action:
                let section = NSCollectionLayoutSection(group: self.groupItem)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
                return section
            case .favorite:
                let group = self.groupItem
                let section = NSCollectionLayoutSection(group: group)
                let header = self.headerItem
                header.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 16)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .paging
                return section
            case .banner:
                return NSCollectionLayoutSection(group: self.groupItem)
            }
        }
    }
}
