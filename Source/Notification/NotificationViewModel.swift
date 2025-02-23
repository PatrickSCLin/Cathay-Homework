//
//  NotificationViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/19.
//

import Combine
import Foundation

final class NotificationViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let notifications: AnyPublisher<[Notification], Never>
    }

    let lastReadTime: Date?

    var notifications: [Notification] { notificationsSubject.value }

    init() {
        self.lastReadTime = UserDefaults.standard.lastNotificationReadTime
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let notifications = Notification.fetchAll()
        notificationsSubject.send(notifications)

        return .init(notifications: notificationsSubject.eraseToAnyPublisher())
    }

    private let notificationsSubject = CurrentValueSubject<[Notification], Never>([])
}
