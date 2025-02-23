//
//  BalanceCellViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import Foundation

enum Currency: String, CaseIterable {
    case usd
    case khr
}

final class BalanceCellViewModel: ViewModelType {
    struct Input {
        let amountVisiableDidSet: AnyPublisher<Bool, Never>
        let infoDidUpdate: AnyPublisher<BalanceModel, Never>
    }

    struct Output {
        let isAmountVisible: AnyPublisher<Bool, Never>
        let currency: AnyPublisher<String, Never>
        let amount: AnyPublisher<String, Never>
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        input.infoDidUpdate
            .sink { [weak self] info in
                guard let self else { return }

                self.currencySubject.send(info.currency.rawValue.uppercased())
                self.amountSubject.send(info.balance)
            }
            .store(in: &cancellables)

        return .init(
            isAmountVisible: input.amountVisiableDidSet
                .eraseToAnyPublisher(),
            currency: currencySubject
                .eraseToAnyPublisher(),
            amount: amountSubject
                .map { value in
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.minimumFractionDigits = 2
                    formatter.maximumFractionDigits = 2
                    return formatter.string(from: NSNumber(value: value)) ?? ""
                }
                .eraseToAnyPublisher()
        )
    }

    private let currencySubject = CurrentValueSubject<String, Never>("")
    private let amountSubject = CurrentValueSubject<Double, Never>(0)
}
