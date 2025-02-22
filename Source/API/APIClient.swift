//
//  APIClient.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/20.
//

import Combine
import Foundation

class APIClient {
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchBalance(currencies: [Currency]) -> AnyPublisher<[BalanceInfo], Error> {
        var publishers: [AnyPublisher<BalanceInfo, Error>] = []
        for currency in currencies {
            publishers.append(fetchBalance(currency: currency).eraseToAnyPublisher())
        }
        return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
    }

    func fetchBalance(currency: Currency) -> AnyPublisher<BalanceInfo, Error> {
        return Publishers.Zip3(fetchSaving(currency: currency),
                               fetchFixedDeposit(currency: currency),
                               fetchDigital(currency: currency))
            .map { saving, fixedDeposit, digital in
                var balance: Double = 0
                for account in saving.accounts + fixedDeposit.accounts + digital.accounts {
                    balance += account.balance
                }

                return BalanceInfo(currency: currency,
                                   balance: balance,
                                   saving: saving.accounts,
                                   fixedDeposit: fixedDeposit.accounts,
                                   digital: digital.accounts)
            }
            .eraseToAnyPublisher()
    }

    private func fetchSaving(currency: Currency) -> AnyPublisher<SavingInfo, Error> {
        return request(URL(string: "https://willywu0201.github.io/data/\(currency.rawValue)Savings2.json")!)
    }

    private func fetchFixedDeposit(currency: Currency) -> AnyPublisher<FixedDepositInfo, Error> {
        return request(URL(string: "https://willywu0201.github.io/data/\(currency.rawValue)Fixed2.json")!)
    }

    private func fetchDigital(currency: Currency) -> AnyPublisher<DigitalInfo, Error> {
        return request(URL(string: "https://willywu0201.github.io/data/\(currency.rawValue)Digital2.json")!)
    }

    private func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private let session: URLSession
}
