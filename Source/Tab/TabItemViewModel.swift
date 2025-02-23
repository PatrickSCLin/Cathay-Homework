//
//  TabItemViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine
import UIKit

final class TabItemViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let title: AnyPublisher<String, Never>
        let image: AnyPublisher<UIImage, Never>
        let isSelected: AnyPublisher<Bool, Never>
    }

    init(title: String, image: UIImage, isSelected: Bool = false) {
        self.title = title
        self.image = image
        self.isSelectedSubject = .init(isSelected)
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        return .init(title: Just(title).eraseToAnyPublisher(),
                     image: Just(image).eraseToAnyPublisher(),
                     isSelected: isSelectedSubject.eraseToAnyPublisher())
    }

    private let title: String
    private let image: UIImage
    private let isSelectedSubject: CurrentValueSubject<Bool, Never>
}
