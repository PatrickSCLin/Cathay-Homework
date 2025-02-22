//
//  TabItemViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

final class TabItemViewModel: ViewModelType {
    struct Input {
        let selectionDidChange: AnyPublisher<Bool, Never>
    }

    struct Output {
        let title: AnyPublisher<String, Never>
        let image: AnyPublisher<UIImage, Never>
        let isSelected: AnyPublisher<Bool, Never>
    }

    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        return .init(title: Just(title).eraseToAnyPublisher(),
                     image: Just(image).eraseToAnyPublisher(),
                     isSelected: input.selectionDidChange)
    }

    private let title: String
    private let image: UIImage
    private let isSelectedSubject: CurrentValueSubject<Bool, Never> = .init(false)
}
