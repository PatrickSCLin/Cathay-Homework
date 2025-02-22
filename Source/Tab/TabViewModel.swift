//
//  TabViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/21.
//

import Combine

final class TabViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let tabs: AnyPublisher<[Tab], Never>
        let selectedIndex: AnyPublisher<Int, Never>
    }

    var tabs: [Tab] { tabsSubject.value }

    init(tabs: [Tab]) {
        self.tabsSubject = .init(tabs)
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        return .init(
            tabs: tabsSubject.eraseToAnyPublisher(),
            selectedIndex: selectedIndexSubject.eraseToAnyPublisher()
        )
    }

    private let tabsSubject: CurrentValueSubject<[Tab], Never>
    private let selectedIndexSubject = CurrentValueSubject<Int, Never>(0)
}
