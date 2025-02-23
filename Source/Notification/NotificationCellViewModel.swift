//
//  NotificationCellViewModel.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/23.
//

import Combine
import Foundation

struct NotificationCellViewModel: ViewModelType {
    struct Input {}

    struct Output {
        let title: AnyPublisher<String, Never>
        let message: AnyPublisher<String, Never>
        let timestamp: AnyPublisher<String, Never>
        let hasRead: AnyPublisher<Bool, Never>
    }

    init(title: String, message: String, timestamp: Date, hasRead: Bool) {
        self.title = title
        self.message = message
        self.timestamp = timestamp
        self.hasRead = hasRead
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let dateFormattr = DateFormatter()
        dateFormattr.dateFormat = "dd-MM-yyyy HH:mm:ss"

        return .init(title: Just(title).eraseToAnyPublisher(),
                     message: Just(message).eraseToAnyPublisher(),
                     timestamp: Just(dateFormattr.string(from: timestamp)).eraseToAnyPublisher(),
                     hasRead: Just(hasRead).eraseToAnyPublisher())
    }

    private let title: String
    private let message: String
    private let timestamp: Date
    private let hasRead: Bool
}
