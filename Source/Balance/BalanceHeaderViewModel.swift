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

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        input.eyeDidTap.sink { [weak self] in
            guard let self else { return }

            self.isAmountVisible.send(!self.isAmountVisible.value)
        }.store(in: &cancellables)

        return .init(isAmountVisible: isAmountVisible.eraseToAnyPublisher())
    }

    private let isAmountVisible = CurrentValueSubject<Bool, Never>(false)
}
