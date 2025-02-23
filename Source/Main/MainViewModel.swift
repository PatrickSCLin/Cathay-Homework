//
//  MainViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import Foundation
import SwiftData

final class MainViewModel: ViewModelType {
    struct Input {
        let viewDidPull: AnyPublisher<Void, Never>
        let notificationDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let isLoadingVisible: AnyPublisher<Bool, Never>
        let hasNewNotification: AnyPublisher<Bool, Never>
        let balances: AnyPublisher<[BalanceModel], Never>
        let actions: AnyPublisher<[Action], Never>
        let favorites: AnyPublisher<[FavoriteModel], Never>
        let banners: AnyPublisher<[BannerInfo], Never>
    }

    var balances: [BalanceModel] { balancesSubject.value }
    var actions: [Action] { actionsSubject.value }
    var favorites: [FavoriteModel] { favoritesSubject.value }
    var banners: [BannerInfo] { bannersSubject.value }
    var tabs: [Tab] { tabsSubject.value }

    let amoustVisiable: CurrentValueSubject<Bool, Never> = .init(false)

    init() {
        var balances = BalanceModel.fetchAll()
        if balances.isEmpty {
            balances = Constants.defaultBalance
        }
        balancesSubject = .init(balances)

        let favorites = FavoriteModel.fetchAll()
        favoritesSubject = .init(favorites)

        actionsSubject = .init(Constants.defaultActions)
        bannersSubject = .init([])
        tabsSubject = .init(Constants.defaultTabs)

        let lastReadTime = UserDefaults.standard.lastNotificationReadTime ?? Date(timeIntervalSince1970: 0)
        let hasNewNotification = NotificationModel.hasNewMessage(lastUpdateDatetime: lastReadTime)
        hasNewNotificationSubject = .init(hasNewNotification)

        fetchBanners()
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        input.viewDidPull
            .sink { [weak self] _ in
                guard let self else { return }

                self.isLoadingVisibleSubject.send(true)
                self.fetchData()
            }
            .store(in: &cancellables)

        input.notificationDidTap
            .sink { [weak self] _ in
                UserDefaults.standard.lastNotificationReadTime = Date()
                self?.hasNewNotificationSubject.send(false)
            }
            .store(in: &cancellables)

        return .init(isLoadingVisible: isLoadingVisibleSubject.eraseToAnyPublisher(),
                     hasNewNotification: hasNewNotificationSubject.eraseToAnyPublisher(),
                     balances: balancesSubject.eraseToAnyPublisher(),
                     actions: actionsSubject.eraseToAnyPublisher(),
                     favorites: favoritesSubject.eraseToAnyPublisher(),
                     banners: bannersSubject.eraseToAnyPublisher())
    }

    private func fetchBanners() {
        APIClient().fetchBanners()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { [weak self] bannersInfo in
                self?.bannersSubject.send(bannersInfo.banners)
            }
            .store(in: &requestCancellables)
    }

    private func fetchData() {
        requestCancellables = []

        let apiClient = APIClient()
        Publishers.Zip3(
            apiClient.fetchNotifications()
                .flatMap { notificationsInfo in
                    let notifications = notificationsInfo
                        .notifications
                        .map { NotificationModel(title: $0.title,
                                                 message: $0.message,
                                                 status: $0.status,
                                                 updateDateTime: $0.updateDateTime) }
                    Database.shared.save(notifications)
                    let lastReadTime = UserDefaults.standard.lastNotificationReadTime ?? Date(timeIntervalSince1970: 0)
                    return Just(NotificationModel.hasNewMessage(lastUpdateDatetime: lastReadTime))
                },
            apiClient.fetchBalances(currencies: Currency.allCases)
                .flatMap { balanceInfos in
                    let balances = balanceInfos
                        .map { BalanceModel(currency: $0.currency, balance: $0.balance) }
                    Database.shared.save(balances)
                    return Just(balances)
                },
            apiClient.fetchFavorites()
                .flatMap { favoritesInfo in
                    var favorites = [FavoriteModel]()
                    for (index, favoriteInfo) in favoritesInfo.favorites.enumerated() {
                        let favorite = FavoriteModel(nickname: favoriteInfo.nickname,
                                                     transType: favoriteInfo.transType,
                                                     index: index)
                        favorites.append(favorite)
                    }
                    Database.shared.save(favorites)
                    return Just(favorites)
                }
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

            self.isLoadingVisibleSubject.send(false)
        } receiveValue: { [weak self] hasNewNotification, balances, favorites in
            self?.balancesSubject.send(balances)
            self?.favoritesSubject.send(favorites)
            self?.hasNewNotificationSubject.send(hasNewNotification)
        }
        .store(in: &requestCancellables)
    }

    private let isLoadingVisibleSubject = CurrentValueSubject<Bool, Never>(false)
    private let hasNewNotificationSubject: CurrentValueSubject<Bool, Never>
    private let balancesSubject: CurrentValueSubject<[BalanceModel], Never>
    private let actionsSubject: CurrentValueSubject<[Action], Never>
    private let favoritesSubject: CurrentValueSubject<[FavoriteModel], Never>
    private let bannersSubject: CurrentValueSubject<[BannerInfo], Never>
    private let tabsSubject: CurrentValueSubject<[Tab], Never>
    private var requestCancellables: Set<AnyCancellable> = []
}

private enum Constants {
    static let defaultBalance: [BalanceModel] = [
        .init(currency: .usd, balance: 45001),
        .init(currency: .khr, balance: 4500000)
    ]

    static let defaultActions: [Action] = [
        .transfer, .payment, .utility,
        .qrcodeScan, .qrcodePay, .topUp
    ]

    static let defaultTabs: [Tab] = [
        .home, .account, .location, .service
    ]
}
