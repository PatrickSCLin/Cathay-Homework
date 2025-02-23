//
//  Notification.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/22.
//

import Combine
import Foundation
import SwiftData

@Model
final class Notification {
    var title: String
    var message: String
    var status: Bool

    @Attribute(.unique)
    var updateDateTime: Date

    init(title: String, message: String, status: Bool, updateDateTime: Date) {
        self.title = title
        self.message = message
        self.status = status
        self.updateDateTime = updateDateTime
    }
}

extension Notification {
    static func hasNewMessage(lastUpdateDatetime: Date) -> Bool {
        var descriptor = FetchDescriptor<Notification>()
        descriptor.predicate = #Predicate<Notification> { $0.updateDateTime > lastUpdateDatetime }
        descriptor.sortBy = [SortDescriptor(\.updateDateTime, order: .reverse)]
        return (try? Database.shared.context.fetch(descriptor).first) != nil
    }

    static func fetchAll() -> [Notification] {
        var descriptor = FetchDescriptor<Notification>()
        descriptor.sortBy = [SortDescriptor(\.updateDateTime, order: .reverse)]
        return (try? Database.shared.context.fetch(descriptor)) ?? []
    }
}
