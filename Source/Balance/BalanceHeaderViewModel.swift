//
//  BalanceHeaderViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import Combine

final class BalanceHeaderViewModel: ViewModelType {
    struct Input {
        let eyeDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let isAmountVisible: AnyPublisher<Bool, Never>
    }

    init(amoutVisible: CurrentValueSubject<Bool, Never>) {
        self.amoutVisible = amoutVisible
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        input.eyeDidTap.sink { [weak self] in
            guard let self else { return }

            self.amoutVisible.send(!self.amoutVisible.value)
        }.store(in: &cancellables)

        return .init(isAmountVisible: amoutVisible.eraseToAnyPublisher())
    }

    private let amoutVisible: CurrentValueSubject<Bool, Never>
}
