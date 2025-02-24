//
//  FavoriteCellViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import UIKit

final class FavoriteCellViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let title: AnyPublisher<String, Never>
        let image: AnyPublisher<UIImage, Never>
    }

    init(title: String, type: FavoriteType) {
        self.title = title
        self.type = type
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        return .init(title: Just(title).eraseToAnyPublisher(),
                     image: Just(type.image).eraseToAnyPublisher())
    }

    private let title: String
    private let type: FavoriteType
}
