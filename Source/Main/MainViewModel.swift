//
//  MainViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine

final class MainViewModel: ViewModelType {
    struct Input {
        let viewDidPull: AnyPublisher<Void, Never>
    }

    struct Output {
        let isLoadingVisible: AnyPublisher<Bool, Never>
        let hasNewNotification: AnyPublisher<Bool, Never>
        let balance: AnyPublisher<[BalanceInfo], Never>
    }

    var balances: [BalanceInfo] { balancesSubject.value }
    var actions: [Action] { actionsSubject.value }
    var favorites: [Favorite] { favoritesSubject.value }
    var banners: [Banner] { bannersSubject.value }
    var tabs: [Tab] { tabsSubject.value }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        input.viewDidPull
            .sink { [weak self] _ in
                guard let self else { return }

                isLoadingVisibleSubject.send(true)
            }
            .store(in: &cancellables)

        return .init(isLoadingVisible: isLoadingVisibleSubject.eraseToAnyPublisher(),
                     hasNewNotification: hasNewNotificationSubject.eraseToAnyPublisher(),
                     balance: balancesSubject.eraseToAnyPublisher())
    }

    private let isLoadingVisibleSubject = CurrentValueSubject<Bool, Never>(false)
    private let hasNewNotificationSubject = CurrentValueSubject<Bool, Never>(false)
    private let balancesSubject = CurrentValueSubject<[BalanceInfo], Never>(Constants.defaultBalance)
    private let actionsSubject = CurrentValueSubject<[Action], Never>(Constants.defaultActions)
    private let favoritesSubject = CurrentValueSubject<[Favorite], Never>(Constants.defaultFavorites)
    private let bannersSubject = CurrentValueSubject<[Banner], Never>(Constants.defaultBanners)
    private let tabsSubject = CurrentValueSubject<[Tab], Never>(Constants.defaultTabs)
}

private enum Constants {
    static let defaultBalance: [BalanceInfo] = [
        .init(currency: .usd, balance: 45001, saving: [
            .init(account: "44558824", curr: "USD", balance: 10000.78),
            .init(account: "77990025", curr: "USD", balance: 5000)
        ], fixedDeposit: [
            .init(account: "44558822", curr: "USD", balance: 10000.11),
            .init(account: "77990023", curr: "USD", balance: 5000)
        ], digital: [
            .init(account: "44558820", curr: "USD", balance: 10000),
            .init(account: "77990021", curr: "USD", balance: 5000.11)
        ]),
        .init(currency: .khr, balance: 4500000, saving: [
            .init(account: "44558814", curr: "KHR", balance: 1000000),
            .init(account: "77990015", curr: "KHR", balance: 500000)
        ], fixedDeposit: [
            .init(account: "44558812", curr: "KHR", balance: 1000000),
            .init(account: "77990013", curr: "KHR", balance: 500000)
        ], digital: [
            .init(account: "44558810", curr: "KHR", balance: 1000000),
            .init(account: "77990011", curr: "KHR", balance: 500000)
        ])
    ]

    static let defaultActions: [Action] = [
        .transfer, .payment, .utility,
        .qrcodeScan, .qrcodePay, .topUp
    ]

    static let defaultFavorites: [Favorite] = [
        .branches, .contacts, .insurance, .creditCard, .extra
    ]

    static let defaultBanners: [Banner] = [
        .banner1, .banner2, .banner3
    ]

    static let defaultTabs: [Tab] = [
        .home, .account, .location, .service
    ]
}
