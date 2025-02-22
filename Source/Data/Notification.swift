//
//  Notification.swift
//  CUB App
//
//  Created by Patrick Lin on 2025/2/22.
//

import Foundation
import SwiftData

@Model
final class Notification {
    var title: String
    var message: String
    var status: Bool
    var updateDatetime: Date

    init(title: String, message: String, status: Bool, updateDatetime: Date) {
        self.title = title
        self.message = message
        self.status = status
        self.updateDatetime = updateDatetime
    }
}
