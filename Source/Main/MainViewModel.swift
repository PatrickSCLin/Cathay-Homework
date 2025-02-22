//
//  MainViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import Foundation

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
    var favorites: [FavoriteInfo] { favoritesSubject.value }
    var banners: [BannerInfo] { bannersSubject.value }
    var tabs: [Tab] { tabsSubject.value }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        input.viewDidPull
            .sink { [weak self] _ in
                guard let self else { return }

                self.isLoadingVisibleSubject.send(true)
                self.fetchData()
            }
            .store(in: &cancellables)

        return .init(isLoadingVisible: isLoadingVisibleSubject.eraseToAnyPublisher(),
                     hasNewNotification: hasNewNotificationSubject.eraseToAnyPublisher(),
                     balance: balancesSubject.eraseToAnyPublisher())
    }

    private func fetchData() {
        requestCancellables = []

        let apiClient = APIClient()
        Publishers.Zip4(
            apiClient.fetchNotifications(),
            apiClient.fetchBalances(currencies: Currency.allCases),
            apiClient.fetchFavorites(),
            apiClient.fetchBanners()
        )
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }

            switch completion {
            case .finished:
                break
            case let .failure(error):
                print(error)
            }

            print("patricksclin 2 \(self.favorites.count)")
            self.isLoadingVisibleSubject.send(false)
            print("patricksclin 3 \(self.favorites.count)")
        } receiveValue: { [weak self] notificationsInfo, balanceInfos, favoritesInfo, bannersInfo in
            print("patricksclin 1 \(favoritesInfo.favorites.count)")
            self?.balancesSubject.send(balanceInfos)
            self?.favoritesSubject.send(favoritesInfo.favorites)
            self?.bannersSubject.send(bannersInfo.banners)
            self?.hasNewNotificationSubject.send(!notificationsInfo.notifications.isEmpty)
        }
        .store(in: &requestCancellables)
    }

    private let isLoadingVisibleSubject = CurrentValueSubject<Bool, Never>(false)
    private let hasNewNotificationSubject = CurrentValueSubject<Bool, Never>(false)
    private let balancesSubject = CurrentValueSubject<[BalanceInfo], Never>(Constants.defaultBalance)
    private let actionsSubject = CurrentValueSubject<[Action], Never>(Constants.defaultActions)
    private let favoritesSubject = CurrentValueSubject<[FavoriteInfo], Never>([])
    private let bannersSubject = CurrentValueSubject<[BannerInfo], Never>([])
    private let tabsSubject = CurrentValueSubject<[Tab], Never>(Constants.defaultTabs)
    private var requestCancellables: Set<AnyCancellable> = []
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

    static let defaultTabs: [Tab] = [
        .home, .account, .location, .service
    ]
}
