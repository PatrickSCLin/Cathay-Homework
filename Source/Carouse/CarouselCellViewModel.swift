//
//  CarouselCellViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

final class CarouselCellViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let image: AnyPublisher<UIImage, Never>
    }

    init(image: UIImage) {
        self.image = image
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        return .init(image: Just(image).eraseToAnyPublisher())
    }

    private let image: UIImage
}
